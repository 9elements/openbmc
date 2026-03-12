FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

#SRC_URI:append = " \
#    file://blacklist.json \
#    file://0001-schemas-legacy-Add-MuxChannel-object.patch \
#    file://0002-Support-MuxChannel-object-for-dynamic-buses.patch \
#    file://0003-overlay-Print-error-instead-crashing.patch \
#    file://0004-ibm-Move-SPYRE-to-separate-JSON.patch \
#    file://0005-ibm-system1-Add-RAA228234-temperature-to-the-PID-loo.patch \
#    file://0006-ibm-system1-Add-CPU-temperature-sensors-to-PID-loop.patch \
#    file://0007-ibm-system1-Add-Spyre-chip-temperature-to-the-PID-lo.patch \
#    file://0008-overlay-Fix-Support-MuxChannel-object-for-dynamic-bu.patch \
#    "
SRC_URI:append = " \
    file://blacklist.json \
    "

do_install:append () {
    install -m 0644 -D ${WORKDIR}/blacklist.json ${D}${datadir}/${PN}/blacklist.json
}
