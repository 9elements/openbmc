FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-5.15-42"
LINUX_VERSION = "5.15.50"

SRCREV = "ec1f5425a3cd5acab1f339d958b4b25dbc790543"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
