#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "gpio.h"
#include "internal.h"
#include "print_buffer.h"

#define EXIT_SUCCESS 0
#define TIMEOUT_IPMB 8

#define POWER_BTN_HIGH 0x3
#define POWER_BTN_LOW 0x2

#define NETFN_APP_REQ 0x06
#define CMD_APP_MASTER_WRITE_READ 0x52

const static char *gpio_server_stby_pwr_sts[] =
{
  "", // index with 1-basde 'slot'
  "PWROK_STBY_BMC_SLOT1",
  "PWROK_STBY_BMC_SLOT2",
  "PWROK_STBY_BMC_SLOT3",
  "PWROK_STBY_BMC_SLOT4"
};

ipmb_req_t *create_request(int val, size_t* tlen)
{
	ipmb_req_t *req = (ipmb_req_t *)malloc(sizeof(ipmb_req_t));
	if (req == NULL) {
		perror("malloc");
		return NULL;
	}

	uint16_t txlen = 5;
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
	print_buffer(txbuf, txlen);

	req->res_slave_addr = BRIDGE_SLAVE_ADDR << 1;
	req->netfn_lun = NETFN_APP_REQ << LUN_OFFSET;
	req->hdr_cksum = req->res_slave_addr + req->netfn_lun;
	req->hdr_cksum = ZERO_CKSUM_CONST - req->hdr_cksum;
	req->req_slave_addr = BMC_SLAVE_ADDR << 1;
	req->seq_lun = 0x00;
	req->cmd = CMD_APP_MASTER_WRITE_READ;

	//TODO: create the checksum at the end of the request
	printf("TODO: checksum\n");
	//TODO: create the BIC UART debug setup
	exit(1);
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
	ipmb_write(fd, (unsigned char *)req, tlen);

	free(req);
	return EXIT_SUCCESS;
}

int enable_i2c_gpio(uint8_t slot){

	if(slot <= 0){
		return -1;
	}

	char* tmplt = (char*)"gpioset $(gpiofind \"FM_SLOT%d_ISOLATED_EN\")=1";
	char buf[100];
	sprintf(buf, tmplt, slot);

	printf("running '%s'\n", buf);

	int status = system(buf);
	return WEXITSTATUS(status);
}

int bic_power_blade(int fd, uint8_t slot) {

	int status = 0;

	status = enable_i2c_gpio(slot);
	if (status != 0) return status;

	status |= send_power_signal(fd, POWER_BTN_HIGH);
	status |= send_power_signal(fd, POWER_BTN_LOW);
	sleep(1);
	status |= send_power_signal(fd, POWER_BTN_HIGH);

	return status;
}

bool gpio_check_blade_power(uint8_t slot){

	char* gpio_name = (char*)gpio_server_stby_pwr_sts[slot];
	return gpio_read_by_name(gpio_name) == 1;
}

