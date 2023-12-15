FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.5-7"
LINUX_VERSION = "6.5.4"

SRCREV = "c64fbce7ac4a7e7ec1ffd17a2cea3631cb65507f"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
