#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "raw-power-gpio.h"
#include "internal.h"
#include "print_buffer.h"
#include "raw_power.h"

const static char *gpio_server_stby_pwr_sts[] =
{
  "", // index with 1-basde 'slot'
  "PWROK_STBY_BMC_SLOT1",
  "PWROK_STBY_BMC_SLOT2",
  "PWROK_STBY_BMC_SLOT3",
  "PWROK_STBY_BMC_SLOT4"
};

static uint8_t ipmb_checksum(uint8_t* bytes, size_t count) {
	int64_t chk = 0;
	for(size_t i = 0; i < count; i++){
		chk = (chk + (int64_t)bytes[i]) % 256;
	}
	chk = - chk;
	return (uint8_t)chk;
}

ipmb_req_t *create_request(int val, size_t* tlen)
{
	uint16_t txlen = 5;

	ipmb_req_t *req = (ipmb_req_t *)malloc(sizeof(ipmb_req_t)+txlen);
	if (req == NULL) {
		perror("malloc");
		return NULL;
	}

	uint8_t txbuf[5] = { 0 };
	*tlen = txlen;

	// reference for these bytes: 'static int bic_server_power_control' in fb tree
	txbuf[0] = 0x05; //bus id
	txbuf[1] = 0x42; //slave addr
	txbuf[2] = 0x01; //read 1 byte
	txbuf[3] = 0x00; //register offset

	txbuf[4] = val; //power signal

	// write tx buffer into request data array
	memcpy(req->data, txbuf, txlen);

	// debug
	print_buffer((char*)"request", txbuf, txlen);

	req->res_slave_addr = BRIDGE_SLAVE_ADDR << 1;
	req->netfn_lun = NETFN_APP_REQ << LUN_OFFSET;
	req->hdr_cksum = req->res_slave_addr + req->netfn_lun;
	req->hdr_cksum = ZERO_CKSUM_CONST - req->hdr_cksum;
	req->req_slave_addr = BMC_SLAVE_ADDR << 1;
	req->seq_lun = 0x00;
	req->cmd = CMD_APP_MASTER_WRITE_READ;

	size_t buf_len = txlen+3;
	uint8_t* buf = (uint8_t*)malloc(buf_len);

	memcpy(buf, &(req->req_slave_addr), buf_len);

	req->data[txlen] = ipmb_checksum(buf, buf_len);

	free(buf);

	return req;
}

int send_power_signal(int fd, uint8_t val)
{

	size_t txlen;
	// build request
	ipmb_req_t *req;
	req = create_request(val, &txlen);

	unsigned short tlen = IPMB_HDR_SIZE + IPMI_REQ_HDR_SIZE + txlen;

	// write raw i2c

	// NOTE: casting to unsigned char in this context means, casting the request
	// struct to bytes, which (hopefully, the bic on the other side casts back
	// into a request struct)
	print_buffer((char*)"request", (uint8_t*)req, (size_t)txlen);

	ipmb_write(fd, (unsigned char *)req, tlen);

	free(req);
	return EXIT_SUCCESS;
}

// return -1 on failure
// return 0 on success
int enable_i2c_gpio(uint8_t slot){

	if(slot <= 0){
		fprintf(stderr, "%s: wrong slot\n", __func__);
		return -1;
	}

#ifdef OPENBMC_TREE
	char* tmplt = (char*)"gpioset $(gpiofind \"FM_SLOT%d_ISOLATED_EN\")=1";
	char buf[100];
	sprintf(buf, tmplt, slot);
	printf("running '%s'\n", buf);

	int status = system(buf);
	return WEXITSTATUS(status);
#endif
#ifdef FACEBOOK_TREE
	char* tmplt = (char*)"FM_SLOT%d_ISOLATED_EN";
	char buf[100];
	sprintf(buf, tmplt, slot);

	if(gpio_set_by_name(buf, 1) != 0){
		fprintf(stderr, "%s: could not set gpio %s\n", __func__, buf);
		return -1;
	}
#endif
	return 0;
}

// on == true  : power on the system
// on == false : power off the system
int bic_power_blade(int fd, uint8_t slot, bool skip_gpio, bool on) {

	int status = 0;

	if(!skip_gpio){
		status = enable_i2c_gpio(slot);
		if (status != 0) return status;
	}

	status |= send_power_signal(fd, POWER_BTN_HIGH);
	status |= send_power_signal(fd, POWER_BTN_LOW);
	if(on) sleep(1);
	else sleep(6);
	status |= send_power_signal(fd, POWER_BTN_HIGH);

	return status;
}

bool gpio_check_blade_power(uint8_t slot){

#ifdef OPENBMC_TREE
	(void)slot;
	(void)gpio_server_stby_pwr_sts[slot];
	return false;
#endif
#ifdef FACEBOOK_TREE
	char* gpio_name = (char*)gpio_server_stby_pwr_sts[slot];
	return gpio_read_by_name(gpio_name) == 1;
#endif
}

