FILESEXTRAPATHS:prepend:sbp1 := "${THISDIR}/${PN}:"

SRC_URI:append:sbp1 = " \
    file://blacklist.json \
    file://sbp1-cpu-dimms.json \
    file://dbus-remove.patch \
    "

do_install:append:sbp1 () {
    install -m 0644 -D ${WORKDIR}/blacklist.json ${D}${datadir}/${PN}/blacklist.json
    install -d ${D}/usr/share/entity-manager/configurations
    install -m 0444 ${WORKDIR}/sbp1-cpu-dimms.json ${D}/usr/share/entity-manager/configurations
}