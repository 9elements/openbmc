FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.5-3"
LINUX_VERSION = "6.5.4"

SRCREV = "1bc8910402b0b951d3fe949889c69bb288cd5165"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
