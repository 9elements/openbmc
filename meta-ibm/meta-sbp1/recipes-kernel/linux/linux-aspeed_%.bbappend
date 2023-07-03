FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.0-15"
LINUX_VERSION = "6.1.15"

SRCREV = "7c10997d45458e6286dbe89ccb864398836ee810"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
