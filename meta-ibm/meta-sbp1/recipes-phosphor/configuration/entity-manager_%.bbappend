FILESEXTRAPATHS:prepend:sbp1 := "${THISDIR}/${PN}:"

SRC_URI:append:sbp1 = " \
    file://blacklist.json \
    file://sbp1-cpu-dimms.json \
    file://dbus-remove.patch \
    file://0001-SSD.patch \
    file://0001-sbp1-Update-PID-settings.patch \
    file://0002-sbp1-Add-PCH-and-AUX-VRs-to-PID-loop.patch \
    file://0003-sbp1-Add-ruler-drives-to-PID-loop.patch \
    "

do_install:append:sbp1 () {
    install -m 0644 -D ${WORKDIR}/blacklist.json ${D}${datadir}/${PN}/blacklist.json
    install -d ${D}/usr/share/entity-manager/configurations
    install -m 0444 ${WORKDIR}/sbp1-cpu-dimms.json ${D}/usr/share/entity-manager/configurations
}
