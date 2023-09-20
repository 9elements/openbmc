FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:sbp1 = " \
        file://0001-Add-support-for-MAX5970.patch \
        file://0002-Hwmon-Add-support-for-ADM1021.patch \
        "

