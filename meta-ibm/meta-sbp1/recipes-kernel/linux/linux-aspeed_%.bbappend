FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.0-16"
LINUX_VERSION = "6.1.15"

SRCREV = "3ef546b1a3ac3e2efe7188338514253f3566e2be"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
