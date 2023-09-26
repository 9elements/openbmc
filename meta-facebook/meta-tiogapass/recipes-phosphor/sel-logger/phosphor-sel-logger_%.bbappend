FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
"

EXTRA_OEMESON:append = " -Dlog-threshold=true "
