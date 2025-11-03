SUMMARY = "OpenBMC for ASRock - Applications"
PR = "r1"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = " \
        ${PN}-flash \
        ${PN}-system \
        ${PN}-chassis \
        ${PN}-hostmgmt \
        "

PROVIDES += "virtual/obmc-chassis-mgmt"
PROVIDES += "virtual/obmc-flash-mgmt"
PROVIDES += "virtual/obmc-system-mgmt"

RPROVIDES:${PN}-chassis += "virtual-obmc-chassis-mgmt"
RPROVIDES:${PN}-flash += "virtual-obmc-flash-mgmt"
RPROVIDES:${PN}-system += "virtual-obmc-system-mgmt"

SUMMARY:${PN}-chassis = "ASRock Chassis"
RDEPENDS:${PN}-chassis = " \
        x86-power-control \
        "

SUMMARY:${PN}-flash = "ASRock Flash"
RDEPENDS:${PN}-flash = " \
        "

SUMMARY:${PN}-system = "ASRock System"
RDEPENDS:${PN}-system = " \
        dbus-sensors \
        entity-manager \
        phosphor-hwmon \
        phosphor-pid-control \
        "
