FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:append = " file://0001-PSUSensor-Add-raa228234.patch \
                   file://0002-Add-I2CMux-and-I2CBus-objects.patch \
                   file://0003-Use-I2CMux-and-I2CBus-objects-to-get-bus-number.patch"
