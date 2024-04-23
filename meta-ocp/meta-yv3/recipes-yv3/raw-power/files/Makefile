
CFLAGS=-Wall -Wextra -Werror

SRC=raw_power.c internal.c gpio.c main.c print_buffer.c

LINKPATH_CROSS = -Lrecipe-sysroot/lib -Lrecipe-sysroot/usr/lib

LINK=-lipmi -lipmb -lgpiod

all: clean raw_power

raw_power: ${SRC}
	${CXX} ${CFLAGS} -o raw_power ${LINKPATH_CROSS} ${LINK} ${LDFLAGS} ${SRC}

clean:
	rm -f raw_power
