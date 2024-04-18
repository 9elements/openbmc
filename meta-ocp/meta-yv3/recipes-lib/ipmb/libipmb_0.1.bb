# Copyright 2015-present Facebook. All Rights Reserved.
SUMMARY = "IPMB Client Library"
DESCRIPTION = "library for IPMB Client"
SECTION = "base"
PR = "r1"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
#LICENSE = "MIT"
#LIC_FILES_CHKSUM = "file://LICENSE;md5=6ba8ec528da02073b7e1f4124c0f836f"
#LICENSE = "GPL-2.0-or-later"
#LIC_FILES_CHKSUM = "file://ipmb.c;beginline=8;endline=20;md5=da35978751a9d71b73679307c4d296ec"

S = "${WORKDIR}"

SRC_URI = " \
    file://meson.build \
    file://ipmb.c \
    file://ipmb.h \
    "
LOCAL_URI = " \
    file://meson.build \
    file://ipmb.c \
    file://ipmb.h \
    "

DEPENDS += "libipmi libipc"
RDEPENDS:${PN} += "libipmi libipc"

inherit meson pkgconfig
