FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.0-17"
LINUX_VERSION = "6.1.15"

SRCREV = "a2ad57837f86b83620adbc97a974831e7e50176a"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
