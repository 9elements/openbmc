SUMMARY = "raw-power"
DESCRIPTION = "Power-on utility to start specified server."

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit pkgconfig autotools-brokensep

SRC_URI = "\
file://internal.h \
file://internal.c \
file://raw_power.c \
file://enable-i2c \
file://Makefile \
"

S = "${WORKDIR}"

do_install() {
    # create the /usr/bin folder in the rootfs with default permissions
    install -d ${D}${bindir}

    # install the application into the /usr/bin folder with default permissions
    install -m 0755 ${WORKDIR}/raw_power ${D}${bindir}
    install -m 0755 ${WORKDIR}/enable-i2c ${D}${bindir}
}
