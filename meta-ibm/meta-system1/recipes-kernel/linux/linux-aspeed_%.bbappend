FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:append = " file://system1.cfg"

# kconfiglib 14.1.0 in kern-tools-native doesn't support the 'transitional'
# Kconfig keyword introduced in Linux 6.18 (arch/Kconfig), so skip the check.
do_kernel_configcheck[noexec] = "1"

KBRANCH = "dev-6.18"
LINUX_VERSION = "6.18.24"

SRCREV = "68da063267662da17b990c3384d5beceab1cdc80"

SRC_URI:append = " file://0001-ARM-dts-aspeed-system1-Update-with-remaining-changes.patch \
        file://0002-Add-eSPI-device-driver-flash-channel.patch \
        file://0003-mtd-Replace-module_init-with-subsys_initcall.patch \
        file://0004-ARM-dts-aspeed-Add-eSPI-node.patch \
        file://0005-dt-bindings-aspeed-Add-eSPI-controller.patch \
        file://0006-Fix-NULL-device-in-traces.patch \
        file://0007-Add-support-for-espi-vw-oob-perif-channels.patch \
        file://0008-Fix-CPU-stalling-due-to-early-exit-of-espi-driver.patch \
        file://0009-hwmon-pmbus-Add-support-for-RAA228234.patch \
        file://0010-bindings-Add-ibm-spyre-binding.patch \
        file://0011-hwmon-Add-IBM-spyre.patch \
        file://0012-dts-aspeed-aspeed-bmc-ibm-system1-Fix-PCIe-slots.patch \
        "
