FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.5-2"
LINUX_VERSION = "6.5.4"

SRCREV = "677f5da17615c38d6db3921a63bc15d42006c934"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
