FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
inherit systemd
inherit obmc-phosphor-systemd

SRC_URI += " \
            file://phosphor-multi-gpio-presence.json \
            file://dependencies.conf \
           "

FILES:${PN}-presence += " ${datadir}/${PN}/phosphor-multi-gpio-presence.json \
                          ${systemd_system_unitdir}/phosphor-multi-gpio-presence.service.d/dependencies.conf \
                       "

SYSTEMD_LINK:${PN}-presence:append = " ../phosphor-multi-gpio-presence.service:multi-user.target.requires/phosphor-multi-gpio-presence.service"

do_install:append() {
    install -d ${D}${datadir}/phosphor-gpio-monitor/
    install -m 0644 ${WORKDIR}/phosphor-multi-gpio-presence.json ${D}${datadir}/${PN}/
    install -d ${D}${systemd_system_unitdir}/phosphor-multi-gpio-presence.service.d/
    install -m 644 -D ${WORKDIR}/dependencies.conf ${D}${systemd_system_unitdir}/phosphor-multi-gpio-presence.service.d/dependencies.conf
}