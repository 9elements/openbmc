#include "internal.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define EXIT_SUCCESS 0
#define TIMEOUT_IPMB 8

// Power sequence HIGH -> LOW -> sleep 1 -> HIGH
#define POWER_BTN_HIGH 0x3
#define POWER_BTN_LOW 0x2

#define NETFN_APP_REQ 0x06
#define CMD_APP_MASTER_WRITE_READ 0x52

void print_usage()
{
	printf("Usage: raw_power [slot_id]\n");
	printf("slot_id: 1-4\n");
}

int parse_args(int argc, char *argv[])
{
	int bus = 0;
	if (1 == argc) {
		print_usage();
		return EXIT_FAILURE;
	} else if (argc > 2) {
		print_usage();
		return EXIT_FAILURE;
	} else {
		int arg = atoi(argv[1]);
		if (arg < 1 || arg > 4) {
			print_usage();
			return EXIT_FAILURE;
		}
		bus = arg - 1;
	}
	return bus;
}

ipmb_req_t *create_request(int val)
{
	ipmb_req_t *req = (ipmb_req_t *)malloc(sizeof(ipmb_req_t));
	if (req == NULL) {
		perror("malloc");
		return NULL;
	}

	uint16_t txlen = 5;
	uint8_t txbuf[5] = { 0 };

	txbuf[0] = 0x05; //bus id
	txbuf[1] = 0x42; //slave addr
	txbuf[2] = 0x01; //read 1 byte
	txbuf[3] = 0x00; //register offset
	txbuf[4] = val; //power signal

	// write tx buffer into request data array
	memcpy(req->data, txbuf, txlen);

	req->res_slave_addr = BRIDGE_SLAVE_ADDR << 1;
	req->netfn_lun = NETFN_APP_REQ << LUN_OFFSET;
	req->hdr_cksum = req->res_slave_addr + req->netfn_lun;
	req->hdr_cksum = ZERO_CKSUM_CONST - req->hdr_cksum;
	req->req_slave_addr = BMC_SLAVE_ADDR << 1;
	req->seq_lun = 0x00;
	req->cmd = CMD_APP_MASTER_WRITE_READ;
	return req;
}

int send_power_signal(int fd, uint8_t val)
{
	uint8_t tlen;
	// 5 bytes of request data
	uint8_t txlen = 5;
	tlen = IPMB_HDR_SIZE + IPMI_REQ_HDR_SIZE + txlen;
	// build request
	ipmb_req_t *req;
	req = create_request(val);

	// write raw i2c

	// NOTE: casting to unsigned char in this context means, casting the request
	// struct to bytes, which (hopefully, the bic on the other side casts back
	// into a request struct)
	ipmb_write(fd, (unsigned char *)req, tlen);

	free(req);
	return EXIT_SUCCESS;
}

int main(int argc, char *argv[])
{
	int bus = 0, ret;
	struct ipmb_svc *svc = (ipmb_svc*)calloc(1, sizeof(*svc));
	if (!svc)
		return EXIT_FAILURE;

	ret = parse_args(argc, argv);
	if (ret < 0) {
		return EXIT_FAILURE;
	}

	init_i2c_bus(bus, svc);

	send_power_signal(svc->i2c_fd, POWER_BTN_HIGH);
	send_power_signal(svc->i2c_fd, POWER_BTN_LOW);
	sleep(1);
	send_power_signal(svc->i2c_fd, POWER_BTN_HIGH);

	free(svc);

	return EXIT_SUCCESS;
}

//
// tlen = IPMB_HDR_SIZE + IPMI_REQ_HDR_SIZE + txlen;
