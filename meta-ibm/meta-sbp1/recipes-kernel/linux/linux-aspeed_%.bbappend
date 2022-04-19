FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.0-9"
LINUX_VERSION = "6.1.15"

SRCREV = "cbd498cba35edccf28538c3ecaf7b03b684f12f7"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
