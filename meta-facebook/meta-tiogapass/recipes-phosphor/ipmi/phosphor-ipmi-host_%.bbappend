FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
"

PACKAGECONFIG:append = " dynamic-sensors"
