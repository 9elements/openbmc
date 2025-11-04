FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

RDEPENDS:${PN} += "phosphor-gpio-monitor-presence"

PACKAGECONFIG:append = " associations"
SRC_URI:append = " file://associations.json"

do_install:append() {
    install -d ${D}${base_datadir}
    install -m 0755 ${UNPACKDIR}/associations.json ${D}${base_datadir}
}
