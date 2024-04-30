#ifndef RAW_POWER_H
#define RAW_POWER_H

#include <stdint.h>
#include <stdbool.h>

#define EXIT_SUCCESS 0
#define TIMEOUT_IPMB 8

#define POWER_BTN_HIGH 0x3
#define POWER_BTN_LOW 0x2

#define NETFN_APP_REQ 0x06
#define CMD_APP_MASTER_WRITE_READ 0x52

// on == true  : power on the blade
// on == false : power off the blade
int bic_power_blade(int fd, uint8_t slot, bool skip_gpio, bool on);

bool gpio_check_blade_power(uint8_t slot);

int enable_i2c_gpio(uint8_t slot);

#endif
