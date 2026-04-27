# remove xyz.openbmc_project.Ipmi.Internal.SoftPowerOff.service
SOFT_SVC = ""
SOFT_TGTFMT = ""
SOFT_FMT = ""

RDEPENDS:${PN}:remove = "phosphor-watchdog"
