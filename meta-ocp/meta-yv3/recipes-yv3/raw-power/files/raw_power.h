#ifndef RAW_POWER_H
#define RAW_POWER_H

#include <stdint.h>

int bic_power_blade(int fd, uint8_t slot);

bool gpio_check_blade_power(uint8_t slot);

#endif
