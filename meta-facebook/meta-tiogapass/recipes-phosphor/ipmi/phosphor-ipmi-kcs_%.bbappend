KCS_DEVICE = "ipmi-kcs3"
KCS_DEVICE_ALT = "ipmi-kcs2"
SYSTEMD_SERVICE:${PN} += "${PN}@${KCS_DEVICE_ALT}.service"
