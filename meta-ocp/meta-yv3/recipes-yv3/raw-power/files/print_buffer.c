#include <stdio.h>
#include <stdint.h>

#include "print_buffer.h"

void print_buffer(uint8_t* buf, size_t len){

	printf("buffer: ");
	for(size_t i=0; i < len; i++){
		printf("0x%02x ", buf[i]);
	}
	printf("\n");
}
