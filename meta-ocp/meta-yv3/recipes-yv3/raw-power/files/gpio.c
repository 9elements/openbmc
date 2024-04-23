#include <stdio.h>
#include <gpiod.h>
#include <stdlib.h>

#include "gpio.h"

#define CONSUMER "Consumer"

int gpio_read_by_name(char *name) {
    struct gpiod_chip *chip;
    struct gpiod_line *line;
    int value;
    unsigned int chip_num = 0;
    char chipname[32];

    while (1) {
        snprintf(chipname, sizeof(chipname), "gpiochip%u", chip_num);

        chip = gpiod_chip_open_by_name(chipname);
        if (!chip) {
            // No more GPIO chips found, stop searching
            break;
        }

        line = gpiod_chip_find_line(chip, name);
        if (line) {
            // Found the line, now read its value
            if (gpiod_line_request_input(line, CONSUMER) < 0) {
                perror("Request line as input failed\n");
                gpiod_chip_close(chip);
                return -1;
            }

            value = gpiod_line_get_value(line);
            gpiod_line_release(line);
            gpiod_chip_close(chip);
            return value;
        }

        gpiod_chip_close(chip);
        chip_num++;
    }

    fprintf(stderr, "GPIO line with name '%s' not found\n", name);
    return -1;
}

