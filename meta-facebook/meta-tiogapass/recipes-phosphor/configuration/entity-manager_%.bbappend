FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
file://0001-fix-EM-config-for-multiple-pxe1610-on-i2c-bus-5.patch \
file://0002-add-chassis-for-tiogapass.patch \
"

