FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:append = " file://system1.cfg"

SRC_URI:append = " file://0001-ARM-dts-aspeed-ibm-system1-Switch-Ethernet-to-RGMII-.patch \
        file://0002-hwmon-pmbus-Add-support-for-RAA228234.patch \ 
        "
