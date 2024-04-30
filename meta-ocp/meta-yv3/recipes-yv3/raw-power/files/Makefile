
CFLAGS=-Wall -Wextra -Werror -DOPENBMC_TREE -std=c++20

SRC=bic.c  internal.c  main.c  print_buffer.c  raw_power.c subcmd_power_dbus.cpp

LINKPATH_CROSS = -Lrecipe-sysroot/lib -Lrecipe-sysroot/usr/lib

LINK=-lgpiod -lsdbusplus -lsystemd

all: clean raw_power

raw_power: ${SRC}
	${CXX} ${CFLAGS} -o raw_power ${LINKPATH_CROSS} ${LDFLAGS} ${SRC} ${LINK}

clean:
	rm -f raw_power
