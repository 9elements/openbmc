FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
PACKAGECONFIG = "ibm-parser"

FILES:${PN} += " \
                /usr/share/vpd/vpd_inventory.json \
                ${systemd_system_unitdir}/* \
                ${nonarch_base_libdir}/udev/rules.d/70-ibm-spd-parser.rules \
               "

SRC_URI += " \
            file://vpd_inventory.json \
            file://ibm-spd-parser@.service \
            file://70-ibm-spd-parser.rules \
           "

SYSTEMD_SERVICE:${PN} = " \
                         ibm-spd-parser@.service \
                         "

do_install:append() {
        rm -f ${D}${systemd_system_unitdir}/*.service
        rm -f ${D}/${nonarch_base_libdir}/udev/rules.d/*.rules
        rm -rf ${D}/usr/share/vpd/*.json

        install -d ${D}/usr/share/vpd
        install ${WORKDIR}/vpd_inventory.json ${D}/usr/share/vpd
        install -m 0644 ${WORKDIR}/ibm-spd-parser@.service ${D}${systemd_system_unitdir}/
        install -m 0644 ${WORKDIR}/70-ibm-spd-parser.rules ${D}/${nonarch_base_libdir}/udev/rules.d/70-ibm-spd-parser.rules
}
