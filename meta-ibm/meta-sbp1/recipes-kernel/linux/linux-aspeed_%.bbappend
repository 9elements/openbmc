FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.0-22"
LINUX_VERSION = "6.1.15"

SRCREV = "f8591347fb6280dd4b893f066b178e5ab2db1153"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
