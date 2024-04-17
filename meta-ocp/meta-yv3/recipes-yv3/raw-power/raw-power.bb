DESCRIPTION = "Power-on utility to start specified server."
SECTION = "base"
DEPENDS = ""
LICENSE = "CLOSED"

SRC_URI = "git:///home/mox/dev/raw-power;protocol=file;branch=main;"
SRCREV = "847d561b7bbe54f9f4d4efb165a149f8f9585757"

S = "${WORKDIR}"

do_compile() {
    cd ${S}/git
    ${CC} ${CFLAGS} ${LDFLAGS} -c internal.c -o internal.o
    ${CC} ${CFLAGS} ${LDFLAGS} raw_power.c internal.o -o raw_power
}

do_install() {
    # create the /usr/bin folder in the rootfs with default permissions
    install -d ${D}${bindir}

    # install the application into the /usr/bin folder with default permissions
    install ${WORKDIR}/git/raw_power ${D}${bindir}
    install -m 0744 ${WORKDIR}/git/enable-i2c ${D}${bindir}
}
