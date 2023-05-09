FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://blacklist.json \
    file://genesis3-cpu-dimms.json \
    file://dbus-remove.patch \
    "

do_install:append () {
    install -m 0644 -D ${WORKDIR}/blacklist.json ${D}${datadir}/${PN}/blacklist.json
    install -d ${D}/usr/share/entity-manager/configurations
    install -m 0444 ${WORKDIR}/genesis3-cpu-dimms.json ${D}/usr/share/entity-manager/configurations
}
