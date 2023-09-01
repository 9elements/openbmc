FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.0-20"
LINUX_VERSION = "6.1.15"

SRCREV = "091f3b916eab097ecc82b36902a36a169d831397"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
