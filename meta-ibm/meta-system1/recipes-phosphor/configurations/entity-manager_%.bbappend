FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://blacklist.json \
    file://0001-schemas-legacy-Add-MuxChannel-object.patch \
    file://0002-Support-MuxChannel-object-for-dynamic-buses.patch \
    file://0003-overlay-Print-error-instead-crashing.patch \
    file://0004-ibm-Move-SPYRE-to-separate-JSON.patch \
    "

do_install:append () {
    install -m 0644 -D ${UNPACKDIR}/blacklist.json ${D}${datadir}/${PN}/blacklist.json
}
