FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KBRANCH = "dev-6.0-19"
LINUX_VERSION = "6.1.15"

SRCREV = "c2276c9a801b87e5331f6286ae3a6a8e391383ed"

KSRC = "git://github.com/9elements/linux;protocol=https;branch=${KBRANCH}"
SRC_URI += "file://sbp1.cfg"
