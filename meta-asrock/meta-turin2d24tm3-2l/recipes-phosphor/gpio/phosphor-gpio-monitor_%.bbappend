FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://phosphor-multi-gpio-presence.json \
    file://dependencies.conf \
    "

FILES:${PN}-presence += "${systemd_system_unitdir}/phosphor-multi-gpio-presence.service.d/dependencies.conf"

do_install:append() {
    install -d ${D}${systemd_system_unitdir}/phosphor-multi-gpio-presence.service.d/
    install -m 0644 ${UNPACKDIR}/dependencies.conf ${D}${systemd_system_unitdir}/phosphor-multi-gpio-presence.service.d/dependencies.conf
}
