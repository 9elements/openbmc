DEPENDS:append:p10bmc = " cli11"
DEPENDS:append:p10bmc = " nlohmann-json"
DEPENDS:append:p10bmc = " phosphor-dbus-interfaces"
DEPENDS:append:p10bmc = " libgpiod"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SYSTEMD_SERVICE:${PN}:append:p10bmc = " ibm-vpd-parser@.service"
SYSTEMD_SERVICE:${PN}:append:p10bmc = " ibm-isdimm-vpd-parser@.service"
SYSTEMD_SERVICE:${PN}:append:p10bmc = " ibm-spi-vpd-parser@.service"
SYSTEMD_SERVICE:${PN}:append:p10bmc = " system-vpd.service"
SYSTEMD_SERVICE:${PN}:append:p10bmc = " com.ibm.VPD.Manager.service"
SYSTEMD_SERVICE:${PN}:append:p10bmc = " wait-vpd-parsers.service"
SYSTEMD_SERVICE:${PN}:remove:p10bmc = " op-vpd-parser.service"
PACKAGECONFIG:append:p10bmc = " ibm-parser vpd-manager"

FILES:${PN}:append:p10bmc = " ${datadir}/vpd/*.json"

do_install:append:p10bmc() {
        # Remove files that are used by openpower-read-vpd
        DEST=${D}${inventory_envdir}
        rm ${DEST}/inventory
        rm ${D}/${nonarch_base_libdir}/udev/rules.d/70-op-vpd.rules
}

do_install:append:witherspoon() {
        DEST=${D}${inventory_envdir}
        printf "\nEEPROM=/sys/devices/platform/ahb/1e780000.apb/1e780000.apb:bus@1e78a000/1e78a400.i2c/i2c-11/11-0051/eeprom" >> ${DEST}/inventory
}

do_install:append:witherspoon-tacoma() {
        DEST=${D}${inventory_envdir}
        printf "FRUS=BMC,ETHERNET" > ${DEST}/inventory
        printf "\nPATHS=/system/chassis/motherboard/bmc,/system/chassis/motherboard/bmc/eth0" >> ${DEST}/inventory
        printf "\nEEPROM=/sys/devices/platform/ahb/1e780000.apb/1e780000.apb:bus@1e78a000/1e78a600.i2c/i2c-11/11-0051/eeprom" >> ${DEST}/inventory
}

pkg_postinst:${PN}:p10bmc() {
    mkdir -p $D$systemd_system_unitdir/obmc-chassis-poweroff@0.target.wants
    LINK="$D$systemd_system_unitdir/obmc-chassis-poweroff@0.target.wants/wait-vpd-parsers.service"
    TARGET="../wait-vpd-parsers.service"
    ln -s $TARGET $LINK
}
pkg_prerm:${PN}:p10bmc() {
    LINK="$D$systemd_system_unitdir/obmc-chassis-poweroff@0.target.wants/wait-vpd-parsers.service"
    rm $LINK
}

SRC_URI:append:system1 = " file://vpd_inventory.json \
    file://vpd-manager-perform-vpd-recollection.service"

SYSTEMD_SERVICE:${PN}:append:system1 = " vpd-manager-perform-vpd-recollection.service"
FILES:${PN}:append:system1 = " ${datadir}/vpd/*.json"

do_install:append:system1() {
        # Install vpd_inventory
        install -d ${D}${datadir}/vpd/
        install -m 0644 ${WORKDIR}/vpd_inventory.json ${D}${datadir}/vpd/
        # Remove files that are used by openpower-read-vpd
        DEST=${D}${inventory_envdir}
        rm ${DEST}/inventory
        rm ${D}/${nonarch_base_libdir}/udev/rules.d/70-op-vpd.rules
        # Install service files
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${WORKDIR}/vpd-manager-perform-vpd-recollection.service ${D}${systemd_system_unitdir}/
}
