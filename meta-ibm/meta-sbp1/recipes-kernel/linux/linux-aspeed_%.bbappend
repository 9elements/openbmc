FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.0-18"
LINUX_VERSION = "6.1.15"

SRCREV = "9512dbc438b9851b975ccc853deedb2dcae8f95e"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
