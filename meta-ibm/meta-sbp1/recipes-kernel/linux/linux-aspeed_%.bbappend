FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.5-1"
LINUX_VERSION = "6.5.4"

SRCREV = "93ab0de67a3279d9214956d23f3e7c20ff2c8619"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
