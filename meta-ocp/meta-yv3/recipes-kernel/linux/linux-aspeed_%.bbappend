FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://yv3.cfg \
    file://aspeed-bmc-ocp-yv3.dts;subdir=git/arch/${ARCH}/boot/dts/${KMACHINE} \
    "
