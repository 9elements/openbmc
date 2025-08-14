FILESEXTRAPATHS:append := "${THISDIR}/${PN}:${THISDIR}/files:"

SRC_URI += " \
    file://0001-ast2600-add-ASRock-Turin2d24tm3-2l-dts.patch \
    file://0002-board-aspeed-turin2d24tm3-2l-disable-gpio-passthrough.patch \
    file://turin2d24tm3-2l.cfg \
    "
