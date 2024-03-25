SUMMARY = "OpenBMC for OCP - Applications"
PR = "r1"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = " \
        ${PN}-chassis \
        ${PN}-fans \
        ${PN}-flash \
        ${PN}-system \
        "

PROVIDES += "virtual/obmc-chassis-mgmt"
PROVIDES += "virtual/obmc-fan-mgmt"
PROVIDES += "virtual/obmc-flash-mgmt"
PROVIDES += "virtual/obmc-system-mgmt"

RPROVIDES:${PN}-chassis += "virtual-obmc-chassis-mgmt"
RPROVIDES:${PN}-fans += "virtual-obmc-fan-mgmt"
RPROVIDES:${PN}-flash += "virtual-obmc-flash-mgmt"
RPROVIDES:${PN}-system += "virtual-obmc-system-mgmt"

SUMMARY:${PN}-chassis = "OCP Chassis"
RDEPENDS:${PN}-chassis = " \
        x86-power-control \
        obmc-host-failure-reboots \
        phosphor-state-manager-chassis \
        "

SUMMARY:${PN}-fans = "OCP Fans"
RDEPENDS:${PN}-fans = " \
        phosphor-pid-control \
        "

SUMMARY:${PN}-flash = "OCP Flash"
RDEPENDS:${PN}-flash = " \
        flashrom \
        phosphor-ipmi-flash \
        phosphor-software-manager \
        "

SUMMARY:${PN}-system = "OCP System"
RDEPENDS:${PN}-system = " \
        bmcweb \
        dbus-sensors \
        entity-manager \
        ipmitool \
        phosphor-hostlogger \
        phosphor-host-postd \
        phosphor-ipmi-ipmb \
        phosphor-ipmi-kcs \
        phosphor-misc-usb-ctrl \
        phosphor-post-code-manager \
        phosphor-sel-logger \
        phosphor-software-manager \
        phosphor-virtual-sensor \
        phosphor-watchdog \
        webui-vue \
        "
