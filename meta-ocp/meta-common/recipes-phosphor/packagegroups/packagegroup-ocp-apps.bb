SUMMARY = "OpenBMC for OCP - Applications"
PR = "r1"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = " \
        ${PN}-chassis \
        ${PN}-flash \
        ${PN}-system \
        ${PN}-fans \
        "

PROVIDES += "virtual/obmc-chassis-mgmt"
PROVIDES += "virtual/obmc-flash-mgmt"
PROVIDES += "virtual/obmc-system-mgmt"
PROVIDES += "virtual/obmc-fan-mgmt"

RPROVIDES:${PN}-chassis += "virtual-obmc-chassis-mgmt"
RPROVIDES:${PN}-flash += "virtual-obmc-flash-mgmt"
RPROVIDES:${PN}-system += "virtual-obmc-system-mgmt"
RPROVIDES:${PN}-fans += "virtual-obmc-fan-mgmt"

SUMMARY:${PN}-chassis = "OCP Chassis"
RDEPENDS:${PN}-chassis = " \
        "

SUMMARY:${PN}-flash = "OCP Flash"
RDEPENDS:${PN}-flash = " \
        "

SUMMARY:${PN}-system = "OCP System"
RDEPENDS:${PN}-system = " \
        "

SUMMARY:${PN}-fans = "OCP Fans"
RDEPENDS:${PN}-fans = " \
        "
