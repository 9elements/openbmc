# Copyright 2018-present Facebook. All Rights Reserved.
SUMMARY = "IPC Helper Library"
DESCRIPTION = "library to abstract away IPC from user (Underlying implementation could be socket or dbus)"
SECTION = "base"
PR = "r1"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
#LICENSE = "GPL-2.0-or-later"
#LIC_FILES_CHKSUM = "file://ipc.c;beginline=5;endline=17;md5=da35978751a9d71b73679307c4d296ec"

S = "${WORKDIR}"

LOCAL_URI = "\
    file://meson.build \
    file://ipc.c \
    file://ipc.h \
    file://ipc-test.c \
    "
SRC_URI = "\
    file://meson.build \
    file://ipc.c \
    file://ipc.h \
    file://ipc-test.c \
    "

inherit meson pkgconfig
#inherit ptest-meson
inherit ptest
inherit meson

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
