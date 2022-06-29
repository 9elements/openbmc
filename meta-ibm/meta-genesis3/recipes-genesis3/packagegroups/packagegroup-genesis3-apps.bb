SUMMARY = "OpenBMC for Genesis3 - Applications"

PR = "r1"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = " \
    ${PN}-chassis \
    ${PN}-flash \
    "

PROVIDES += "virtual/obmc-flash-mgmt"
PROVIDES += "virtual/obmc-chassis-mgmt"

RPROVIDES:${PN}-chassis += "virtual-obmc-chassis-mgmt"
RPROVIDES:${PN}-flash += "virtual-obmc-flash-mgmt"

SUMMARY:${PN}-flash = "IBM Flash utils"
RDEPENDS:${PN}-flash = " \
    obmc-control-bmc \
    flashrom \
    "

SUMMARY:${PN}-chassis = "Chassis power control"
RDEPENDS:${PN}-chassis = " \
    phosphor-post-code-manager \
    phosphor-host-postd \
"
