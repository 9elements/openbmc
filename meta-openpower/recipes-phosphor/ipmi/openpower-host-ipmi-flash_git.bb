SUMMARY = "Phosphor IPMI plugin for the Host I/O Mapping Protocol"
HOMEPAGE = "https://github.com/openbmc/openpower-host-ipmi-flash"
PR = "r1"
PV = "0.1+git${SRCPV}"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=ff331e820fda701d36a8f0efc98adc58"

inherit autotools pkgconfig
inherit obmc-phosphor-ipmiprovider-symlink

DEPENDS += "phosphor-ipmi-host"
DEPENDS += "autoconf-archive-native"
DEPENDS += "sdbusplus"
DEPENDS += "phosphor-logging"
DEPENDS += "phosphor-dbus-interfaces"

TARGET_CFLAGS += "-fpic"

HOSTIPMI_PROVIDER_LIBRARY += "libhiomap.so"

S = "${WORKDIR}/git"

SRC_URI += "git://github.com/openbmc/openpower-host-ipmi-flash;branch=master;protocol=https"
SRCREV = "299cb81ee95e7e0fc510094e10c16d4d015e0637"

FILES:${PN}:append = " ${libdir}/ipmid-providers/lib*${SOLIBS}"
FILES:${PN}:append = " ${libdir}/host-ipmid/lib*${SOLIBS}"
FILES:${PN}-dev:append = " ${libdir}/ipmid-providers/lib*${SOLIBSDEV} ${libdir}/ipmid-providers/*.la"
