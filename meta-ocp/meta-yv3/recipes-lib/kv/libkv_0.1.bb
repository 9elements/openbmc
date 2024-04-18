# Copyright 2016-present Facebook. All Rights Reserved.
#
# This program file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program in a file named COPYING; if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301 USA

SUMMARY = "KV Store Library"
DESCRIPTION = "library for get set of kv pairs"
SECTION = "base"
PR = "r1"
LICENSE = "GPL-2.0-only"

# The license GPL-2.0 was removed in Hardknott.
# Use GPL-2.0-only instead.
def lic_file_name(d):
    distro = d.getVar('DISTRO_CODENAME', True)
    if distro in [ 'rocko', 'dunfell' ]:
        return "GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

    return "GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

LIC_FILES_CHKSUM = "\
    file://${COREBASE}/meta/files/common-licenses/${@lic_file_name(d)} \
    "

inherit meson pkgconfig python3-dir
#inherit ptest-meson
inherit ptest
inherit meson

S = "${WORKDIR}"

DEPENDS += "\
    ptest-meson-crosstarget-native \
    chrpath-native \
    "

RDEPENDS:${PN}-ptest += "meson"

do_compile:append() {
    cat <<EOF > ${WORKDIR}/run-ptest
#!/bin/sh
meson test --no-rebuild --verbose
EOF

}

do_install_ptest() {
    # Fix up meson private data to run on target.
    ptest-meson-crosstarget --install-path ${PTEST_PATH} --package-path ${B}

    # Create destination directories.
    install -d ${D}${PTEST_PATH}
    install -d ${D}${PTEST_PATH}/meson-private
    install -d ${D}${PTEST_PATH}/meson-logs

    # Install executables with the name test-*
    for file in ${B}/test-*
    do
        if [ -f ${file} ]; then
            install -m 0755 ${file} ${D}${PTEST_PATH}/
            # Meson 0.40 (Rocko) adds incorrect RPATHs, so delete them.
            chrpath -d ${D}${PTEST_PATH}/$(basename ${file})
        fi
    done

    # Install meson data.
    for file in ${B}/meson-private/*.dat
    do
        install -m 0644 ${file} ${D}${PTEST_PATH}/meson-private
    done
}

SRC_URI = " \
    file://fileops.cpp \
    file://fileops.hpp \
    file://kv-util.cpp \
    file://kv.cpp \
    file://kv.h \
    file://kv.hpp \
    file://kv.py \
    file://log.hpp \
    file://meson.build \
    file://test-kv.cpp \
    "
LOCAL_URI = " \
    file://fileops.cpp \
    file://fileops.hpp \
    file://kv-util.cpp \
    file://kv.cpp \
    file://kv.h \
    file://kv.hpp \
    file://kv.py \
    file://log.hpp \
    file://meson.build \
    file://test-kv.cpp \
    "

DEPENDS += "python3-setuptools"
RDEPENDS:${PN} += "python3-core bash"

do_install:append() {
    install -d ${D}${PYTHON_SITEPACKAGES_DIR}
    install -m 644 ${S}/kv.py ${D}${PYTHON_SITEPACKAGES_DIR}/
}
FILES:${PN} += "${PYTHON_SITEPACKAGES_DIR}/kv.py"

BBCLASSEXTEND = "native nativesdk"
