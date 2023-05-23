FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:p10bmc = "hwmontempsensor"
PACKAGECONFIG:sbp1 = " \
    hwmontempsensor \
    fansensor \
    psusensor \
    intelcpusensor \
    adcsensor \
    "
SRC_URI:append:sbp1 = " \
		file://0001-IntelCPUSensor-retry-when-hwmon-nodes-not-found.patch     \
		file://0002-IntelCPUSensor-support-new-Linux-PECI-API.patch \
		"
