FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:turin2d24tm3-2l = " \
    file://blocklist.json \
    file://turin2d24tm3-2l-baseboard.json \
    file://acbel_r1ca2202b_psu.json \
    file://turin2d24tm3-2l-fans.json \
    "

do_install:append:turin2d24tm3-2l() {
    install -d ${D}${datadir}/entity-manager/configurations
    install -m 0644 -D ${UNPACKDIR}/blocklist.json \
        ${D}${datadir}/entity-manager
    install -m 0644 -D ${UNPACKDIR}/turin2d24tm3-2l-baseboard.json \
        ${D}${datadir}/entity-manager/configurations
    install -m 0644 -D ${UNPACKDIR}/acbel_r1ca2202b_psu.json \
        ${D}${datadir}/entity-manager/configurations
    install -m 0644 -D ${UNPACKDIR}/turin2d24tm3-2l-fans.json \
        ${D}${datadir}/entity-manager/configurations
}
