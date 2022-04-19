FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.0-10"
LINUX_VERSION = "6.1.15"

SRCREV = "1f448773c4676a3be91c9c5427cf806b52321653"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
