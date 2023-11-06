FILESEXTRAPATHS:prepend:sbp1 := "${THISDIR}/${PN}:"

SRCREV = "0ae11fe821a0781fd92e084ab4ecb4c0c8f22314"

SRC_URI:append:sbp1 = " \
    file://blacklist.json \
    file://sbp1-cpu-dimms.json \
    file://0001-schemas-Add-more-names-for-labels.patch \
    file://0002-configurations-sbp1-Add-M.2-NVMe-temperature-sensors.patch \
    file://0003-configurations-sbp1-Swap-PVCCIN-and-PVCCFA_EHV_FIRA.patch \
    file://0004-configurations-sbp1-Update-PHY-LDOs.patch \
    file://0005-configuration-sbp1-Add-MAX5970-SSB.patch \
    file://0006-configurations-sbp1-Add-MAX6639.patch \
    file://0007-configurations-sbp1-Fix-typo.patch \
    file://0008-configurations-sbp1-Update-input-label-name.patch \
    file://0009-configuration-sbp1-Configure-PowerState-of-some-supl.patch \
    file://0010-configurations-sbp1-Adjust-thresholds.patch \
    file://0011-Overlay-Remove-installed-drivers-when-probe-is-false.patch \
    file://0012-configurations-Blacklist-P4510-in-PXXX.patch \
    file://0013-configurations-Add-Intel-P4510-SSD.patch \
"

do_install:append:sbp1 () {
    install -m 0644 -D ${WORKDIR}/blacklist.json ${D}${datadir}/${PN}/blacklist.json
    install -d ${D}/usr/share/entity-manager/configurations
    install -m 0444 ${WORKDIR}/sbp1-cpu-dimms.json ${D}/usr/share/entity-manager/configurations
}
