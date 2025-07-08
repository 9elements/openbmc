SUMMARY = "C++ Hello World Example"
DESCRIPTION = "Simple C++ application for OpenBMC workshop"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit meson

SRC_URI = "file://hello.cpp \
          file://meson.build"

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

FILES:${PN} += "${bindir}/hello-cpp"
