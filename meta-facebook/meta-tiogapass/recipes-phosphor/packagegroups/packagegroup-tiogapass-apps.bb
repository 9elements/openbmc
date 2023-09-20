SUMMARY = "tiogapass apps"
PR = "r1"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = " \
  ${PN}-chassis \
  ${PN}-flash \
  ${PN}-system \
"

PROVIDES += "virtual/obmc-chassis-mgmt"
PROVIDES += "virtual/obmc-system-mgmt"
PROVIDES += "virtual/obmc-flash-mgmt"

RPROVIDES:${PN}-chassis = "virtual-obmc-chassis-mgmt"
RPROVIDES:${PN}-system = "virtual-obmc-system-mgmt"
RPROVIDES:${PN}-flash = "virtual-obmc-flash-mgmt"

SUMMARY:${PN}-flash = "Tiogapass Flash"
RDEPENDS:${PN}-flash = " \
 phosphor-software-manager \
"

SUMMARY:${PN}-system = "Tiogapass System"
RDEPENDS:${PN}-system = " \
 entity-manager \
 dbus-sensors \
 phosphor-sel-logger \
 ipmitool \
 bmcweb \
 webui-vue \
"

RDEPENDS:${PN}-extras:append = " \
 webui-vue \
"

RDEPENDS:${PN}-extras:remove = "phosphor-nslcd-cert-config"
RDEPENDS:${PN}-extras:remove = "phosphor-nslcd-authority-cert-config"

SUMMARY:${PN}-chassis = "Tiogapass Chassis"
RDEPENDS:${PN}-chassis = " \
 x86-power-control \
 fb-powerctrl \
"
