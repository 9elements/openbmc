FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Enable multi-host support for yosemitev3 in phosphor-host-postd
EXTRA_OEMESON += "-Dhost-instances='${OBMC_HOST_INSTANCES}'"
EXTRA_OEMESON:append = " -Dsnoop=enabled"
