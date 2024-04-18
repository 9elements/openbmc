
CFLAGS=-Wall -Wextra -Werror

SRC=raw_power.c internal.c

all: clean raw_power

raw_power: ${SRC}
	${CXX} ${CFLAGS} -o raw_power ${LDFLAGS} ${SRC}

clean:
	rm -f raw_power
