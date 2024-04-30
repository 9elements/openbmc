#ifndef SUBCMD_POWER_DBUS_H
#define SUBCMD_POWER_DBUS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sdbusplus/bus.hpp>
#include <iostream>
#include <vector>

#include "raw_power.h"
#include "internal.h"
#include "bic.h"

void subcmd_power_dbus(int slot, bool skip_gpio, bool on);

#endif
