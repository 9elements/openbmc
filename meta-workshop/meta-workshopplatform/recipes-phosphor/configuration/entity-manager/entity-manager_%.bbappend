FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://workshopplatform.json "

inherit phosphor-inventory-manager

do_install:append(){
    install -d ${D}/usr/share/entity-manager/configurations
    install -m 0444 ${WORKDIR}/workshopplatform.json ${D}/usr/share/entity-manager/configurations
}
