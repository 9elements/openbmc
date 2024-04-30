#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "raw_power.h"
#include "internal.h"
#include "bic.h"
#include "subcmd_power_dbus.hpp"

enum SUBCMD {
	SUBCMD_NONE,
	SUBCMD_POWER,
	SUBCMD_POWER_DBUS,
	SUBCMD_STATUS,
};

void print_usage()
{
	printf("Usage: raw_power power SLOT_ID POWERSTATE [OPTION...]\n");
	printf("Usage: raw_power power-dbus SLOT_ID POWERSTATE [OPTION...]\n");
	printf("Usage: raw_power status SLOT_ID [OPTION...]\n");
	printf("SLOT_ID: 1-4\n");
	printf("POWERSTATE: ON | OFF\n");
	printf("OPTIONS:\n");
	printf("--skip-gpio       skip setting enable gpio, assume i2c bus to blade is already enabled\n");
	printf("\n");
}

int raw_power_parse_args(int argc, char *argv[], int* slot, bool* skip_gpio, bool* on, enum SUBCMD* subcmd)
{
	bool select_powerstate = false;

	if (1 == argc) {
		fprintf(stderr, "not enough flags\n");
		print_usage();
		return EXIT_FAILURE;
	}

	for(int i=1; i < argc; i++){
		char* arg_str = argv[i];

		if(strcmp(arg_str, "power") == 0){
			*subcmd = SUBCMD_POWER;
			continue;
		}
		if(strcmp(arg_str, "status") == 0){
			*subcmd = SUBCMD_STATUS;
			continue;
		}
		if(strcmp(arg_str, "power-dbus") == 0){
			*subcmd = SUBCMD_POWER_DBUS;
			continue;
		}

		if(strcmp(arg_str, "--skip-gpio") == 0){
			*skip_gpio = true;
			continue;
		}

		if(strcmp(arg_str, "on") == 0){
			*on = true;
			select_powerstate = true;
			continue;
		}
		if(strcmp(arg_str, "off") == 0){
			*on = false;
			select_powerstate = true;
			continue;
		}

		int arg = atoi(arg_str);
		if (arg < 1 || arg > 4) {
			fprintf(stderr, "slot %d is out of bounds\n", arg);
			print_usage();
			return EXIT_FAILURE;
		}
		*slot = arg;
	}

	if(!select_powerstate && *subcmd == SUBCMD_POWER){
		fprintf(stderr,"did not select 'on' or 'off'\n");
		print_usage();
		return EXIT_FAILURE;
	}

	return 0;
}

void subcmd_status(struct ipmb_svc* svc, int slot, bool skip_gpio){

	int status = 0;

	if(!skip_gpio){
		status = enable_i2c_gpio(slot);
		if (status != 0) {
			fprintf(stderr, "error when try to enable i2c gpio\n");
			return;
		}
	}

	uint8_t tbuf[3]  = {0};
	uint8_t rbuf[16] = {0};
	size_t tlen = 3;
	size_t rlen = 9; // guess this, as we look into rbuf[8], and need atleast 1 byte checksum after that
	int ret;

	const uint32_t IANA_ID = 0x009c9c;
	memcpy(tbuf, (uint8_t *)&IANA_ID, tlen);

	uint8_t NETFN_OEM_1S_REQ = 0x38;
	uint8_t CMD_OEM_1S_GET_GPIO = 0x3;

	ret = raw_power_bic_ipmb_wrapper(svc->i2c_fd, NETFN_OEM_1S_REQ, CMD_OEM_1S_GET_GPIO, tbuf, tlen, rbuf, &rlen);

	if(ret != 0){
		fprintf(stderr, "error in raw_power_bic_ipmb_wrapper\n");
		return;
	}

	uint8_t power_status = (rbuf[8] & 0x40) >> 6;
	printf("Status: %s\n", (power_status)?"ON":"OFF");
}

void subcmd_power(struct ipmb_svc* svc, int slot, bool skip_gpio, bool on){

	printf("try to power %s slot %d\n", (on)?"on":"off", slot);

	int status = bic_power_blade(svc->i2c_fd, slot, skip_gpio, on);

	if(status != 0){
		fprintf(stderr, "error power control blade %d\n", slot);
	}
/*
	bool powered = gpio_check_blade_power(slot);
	if(powered){
		printf("blade %d is powered\n", slot);
	}else{
		printf("blade %d is not powered\n", slot);
	}
*/

}

int main(int argc, char *argv[])
{
	int bus = 0, ret;
	enum SUBCMD subcmd = SUBCMD_NONE;
	struct ipmb_svc *svc = (ipmb_svc*)calloc(1, sizeof(*svc));
	if (!svc)
		return EXIT_FAILURE;

	int slot = 0;
	bool skip_gpio = false;
	bool on = false;
	ret = raw_power_parse_args(argc, argv, &slot, &skip_gpio, &on, &subcmd);
	if (ret != 0) {
		return EXIT_FAILURE;
	}

	init_i2c_bus(bus, svc);

	switch(subcmd){
	case SUBCMD_POWER:
		subcmd_power(svc, slot, skip_gpio, on);
		break;
	case SUBCMD_POWER_DBUS:
		subcmd_power_dbus(slot, skip_gpio, on);
		break;
	case SUBCMD_STATUS:
		subcmd_status(svc, slot, skip_gpio);
		break;
	case SUBCMD_NONE:
		fprintf(stderr, "no subcommand selected\n");
		print_usage();
		break;
	}

	free(svc);

	return EXIT_SUCCESS;
}

