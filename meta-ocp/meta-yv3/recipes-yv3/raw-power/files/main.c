#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "raw_power.h"
#include "internal.h"

//#include <openbmc/ipmb.h>
//#include <openbmc/ipmi.h>

void print_usage()
{
	printf("Usage: raw_power [slot_id]\n");
	printf("slot_id: 1-4\n");
}

int raw_power_parse_args(int argc, char *argv[], int* slot)
{
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
		*slot = arg;
	}
	return 0;
}

int main(int argc, char *argv[])
{
	int bus = 0, ret;
	struct ipmb_svc *svc = (ipmb_svc*)calloc(1, sizeof(*svc));
	if (!svc)
		return EXIT_FAILURE;

	int slot = 0;
	ret = raw_power_parse_args(argc, argv, &slot);
	if (ret != 0) {
		return EXIT_FAILURE;
	}

	init_i2c_bus(bus, svc);

	printf("try to power on slot %d\n", slot);

	int status = bic_power_blade(svc->i2c_fd, slot);

	if(status != 0){
		fprintf(stderr, "error powering blade %d\n", slot);
	}

	bool powered = gpio_check_blade_power(slot);
	if(powered){
		printf("blade %d is powered\n", slot);
	}else{
		printf("blade %d is not powered\n", slot);
	}

	free(svc);

	return EXIT_SUCCESS;
}

