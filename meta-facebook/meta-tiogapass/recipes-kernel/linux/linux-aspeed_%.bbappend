FILESEXTRAPATHS:prepend := "${THISDIR}/linux-aspeed:"

SRC_URI:append = "\
file://aspeed-bmc-facebook-tiogapass-pruned.dts;subdir=git/arch/${ARCH}/boot/dts \
"

SRC_URI += "file://tiogapass.cfg"
