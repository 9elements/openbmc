FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.5-5"
LINUX_VERSION = "6.5.4"

SRCREV = "0eb02998721ad4d6480ce64b3aa407f49f7ec1f8"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
