FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:sbp1 = " \
        file://0001-Add-support-for-MAX5970.patch \
        "

