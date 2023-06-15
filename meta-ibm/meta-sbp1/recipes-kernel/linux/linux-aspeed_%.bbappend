FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.0-14"
LINUX_VERSION = "6.1.15"

SRCREV = "8f3de75a858ebc3520870f0d7ab8a84d1ea92188"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
