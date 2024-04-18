# Copyright 2015-present Facebook. All Rights Reserved.
SUMMARY = "Power Utility"
DESCRIPTION = "Utility for Power Policy and Management"
SECTION = "base"
PR = "r1"

S = "${WORKDIR}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
#LICENSE = "MIT"
#LIC_FILES_CHKSUM = "file://LICENSE;md5=6ba8ec528da02073b7e1f4124c0f836f"

SRC_URI = " \
    file://meson.build \
    file://power-util.c \
    "
LOCAL_URI = " \
    file://meson.build \
    file://power-util.c \
    "

inherit meson pkgconfig


#inherit legacy-packages
# Many 'legacy' packages use to install into `/usr/local/fbpackages/<pkgdir>`
# and then symlink their binaries into `/usr/local/bin` but the default meson
# behavior is to install into /usr/bin.  This bbclass will find all of the
# executables installed by a package and symlink them back into the 'legacy'
# locations.  This allows scripts to continue working until they are updated
# to reflect the new locatiosn.
#
#
# To use this:
#   - set 'pkgdir' to the legacy /usr/local/fbpackages/<pkgdir> location.
#   - inherit legacy-packages
#
# If 'pkgdir' is not set then only the /usr/local/bin symlinks will be made.

do_install:append() {
    if [ "x${pkgdir}" != "x" ]; then
        pkgpath=${D}/usr/local/fbpackages/${pkgdir}
    fi

    install -d ${D}/usr/local/bin

    for exe in ${D}/${bindir}/* ; do
        exename=$(basename ${exe})

        if [ "x${pkgdir}" != "x" ]; then
            install -d ${pkgpath}
            ln -snf ${bindir}/${exename} ${pkgpath}/${exename}
        fi
        ln -snf ${bindir}/${exename} ${D}/usr/local/bin/${exename}
    done
}

FILES:${PN}:append = " /usr/local/bin /usr/local/fbpackages"

pkgdir = "power-util"

DEPENDS += "libpal"

#CFLAGS:prepend = " -DFRU_DEVICE_LIST "
