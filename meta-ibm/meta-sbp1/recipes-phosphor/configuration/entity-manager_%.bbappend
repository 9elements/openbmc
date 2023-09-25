FILESEXTRAPATHS:prepend:sbp1 := "${THISDIR}/${PN}:"

SRC_URI:append:sbp1 = " \
    file://blacklist.json \
    file://sbp1-cpu-dimms.json \
    file://0001-test-Add-test-for-string-matching.patch \
    file://0002-configurations-Add-Intel-P4510-SSD.patch \
    file://0003-configurations-sbp1-Update-PID-settings.patch \
    file://0004-configurations-sbp1-Add-PCH-and-AUX-VRs-to-PID-loop.patch \
    file://0005-configurations-sbp1-Add-ruler-drives-to-PID-loop.patch \
    file://0006-schemas-Add-more-names-for-labels.patch \
    file://0007-NOTFORMERGE-sbp1-Add-MAX5970-SSB.patch \
    file://0008-configurations-sbp1-Add-M.2-NVMe-temperature-sensors.patch \
    file://0009-configurations-sbp1-Add-RTC-ADC-sensor.patch \
    file://0010-configurations-sbp1-Add-NIC-temperature-sensors.patch \
    file://0011-configurations-sbp1-Add-PCH-temperature-sensor.patch \
    file://0012-Overlay-Remove-installed-drivers-when-probe-is-false.patch \
    "

do_install:append:sbp1 () {
    install -m 0644 -D ${WORKDIR}/blacklist.json ${D}${datadir}/${PN}/blacklist.json
    install -d ${D}/usr/share/entity-manager/configurations
    install -m 0444 ${WORKDIR}/sbp1-cpu-dimms.json ${D}/usr/share/entity-manager/configurations
}
