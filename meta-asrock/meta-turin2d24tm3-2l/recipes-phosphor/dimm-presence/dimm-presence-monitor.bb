SUMMARY = "DIMM Presence Monitor Daemon"
DESCRIPTION = "Monitors DIMM temperature sensor availability and updates inventory Present properties"
PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit systemd

S = "${WORKDIR}/sources"
UNPACKDIR = "${S}"

SRC_URI = " \
    file://dimm-presence-monitor.py \
    file://dimm-presence-monitor.service \
"

RDEPENDS:${PN} += " \
    python3-core \
    python3-dbus \
"

SYSTEMD_SERVICE:${PN} = "dimm-presence-monitor.service"
SYSTEMD_AUTO_ENABLE = "enable"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${UNPACKDIR}/dimm-presence-monitor.py ${D}${bindir}/

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${UNPACKDIR}/dimm-presence-monitor.service ${D}${systemd_system_unitdir}/
}

FILES:${PN} += " \
    ${bindir}/dimm-presence-monitor.py \
    ${systemd_system_unitdir}/dimm-presence-monitor.service \
"
