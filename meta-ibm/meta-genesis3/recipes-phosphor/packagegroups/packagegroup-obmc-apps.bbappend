
RDEPENDS:${PN}-extras:append = "webui-vue ethtool net-tools lmsensors-sensors screen phosphor-ipmi-ipmb ipmitool"
RDEPENDS:${PN}-chassis-state-mgmt:remove = "obmc-phosphor-power obmc-op-control-power"