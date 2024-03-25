FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://tiogapass.cfg \
    file://aspeed-bmc-ocp-tiogapass.dts;subdir=git/arch/${ARCH}/boot/dts/${KMACHINE} \
    "
