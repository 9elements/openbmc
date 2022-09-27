SUMMARY = "A library to abstract stream I/O like serial port, TCP, telnet, etc"
HOMEPAGE = "https://github.com/cminyard/gensio"
LICENSE = "GPL-2.0-only & LGPL-2.1-only"
LIC_FILES_CHKSUM = "file://COPYING.LIB;md5=a0fd36908af843bcee10cb6dfc47fa67 \
                    file://COPYING;md5=bae3019b4c6dc4138c217864bd04331f \
                    "

SRCREV = "b6cd354afe6d5f63bc859c94fd3a455a3cdf0449"

SRC_URI = "git://github.com/cminyard/gensio;protocol=https;branch=master \
           file://0001-tools-gensiot-Fix-build-with-musl.patch \
"

S = "${WORKDIR}/git"

inherit autotools

PACKAGECONFIG ??= "openssl tcp-wrappers"

PACKAGECONFIG[openssl] = "--with-openssl=${STAGING_DIR_HOST}${prefix},--without-openssl, openssl"
PACKAGECONFIG[tcp-wrappers] = "--with-tcp-wrappers,--without-tcp-wrappers, tcp-wrappers"
PACKAGECONFIG[swig] = "--with-swig,--without-swig, swig"

EXTRA_OECONF = "--without-python"

RDEPENDS:${PN} += "bash"