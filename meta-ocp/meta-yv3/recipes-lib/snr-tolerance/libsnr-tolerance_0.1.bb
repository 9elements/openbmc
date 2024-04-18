SUMMARY = "Sensor Reading Tolerance Library"
DESCRIPTION = "Library for Sensor Reading Failure Tolerance"
SECTION = "base"
PR = "r1"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
#LICENSE = "GPL-2.0-or-later"
#LIC_FILES_CHKSUM = "file://snr-tolerance.h;beginline=4;endline=16;md5=da35978751a9d71b73679307c4d296ec"

BBCLASSEXTEND = "native"

inherit meson pkgconfig

S = "${WORKDIR}"

LOCAL_URI = " \
    file://snr-tolerance.h \
    file://snr-tolerance.cpp \
    file://meson.build \
    "

SRC_URI = " \
    file://snr-tolerance.h \
    file://snr-tolerance.cpp \
    file://meson.build \
    "
