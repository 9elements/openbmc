SUMMARY = "A very small and simple terminal emulator"
SECTION = "x11/applications"
DEPENDS = "vte9"

LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://main.c;start_line=5;end_line=16;md5=9ae4bf20caf291afa94530026bd15229"

# 0.2 version
SRCREV = "8586d617aed19fc75f5ae1e07270752c1b2f9a30"
SRC_URI = "git://github.com/OSSystems/toscoterm.git;branch=master;protocol=https"

S = "${WORKDIR}/git"

inherit features_check gitpkgv pkgconfig

REQUIRED_DISTRO_FEATURES = "x11"

do_compile() {
    oe_runmake \
        CC="${CC}" \
        CFLAGS="`pkg-config --cflags vte`${CFLAGS}" \
        LDFLAGS="`pkg-config --libs vte` ${LDFLAGS}"
}

do_install() {
    oe_runmake PREFIX="${prefix}" DESTDIR="${D}" install
}

RDEPENDS:${PN}:append:libc-glibc = " glibc-gconv-ibm437"
