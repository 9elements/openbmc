FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://aspeed-bmc-asrock-turin2d24tm3-2l.dts;subdir=git/arch/${ARCH}/boot/dts/aspeed \
    file://turin2d24tm3-2l.cfg \
    "

SRC_URI += " \
    file://0001-drivers-soc-add-old-aspeed-espi-code.patch \
    file://0002-aspeed-video-disable-some-irqs.patch \
    file://0003-dt-bindings-fix-ast2600-pcie-reset-number-declaratio.patch \
    file://0004-spi-prevent-bmc-getting-stuck-in-reboot.patch \
    file://0005-dt-add-ast2600-pwm-dt-node.patch \
    file://0006-drivers-hwmon-create-amdgpu-hwmon.c.patch \
    file://0007-drivers-hwmon-create-netint-hwmon.c.patch \
    file://0008-spi-aspeed-add-shutdown-path-for-AST25XX-SPI-control.patch \
    file://0009-spi-add-user-mode-aspeed-spi-driver.patch \
    file://0010-i2c-aspeed-add-clock-duty-cycle-property.patch \
    file://0011-dt-bindings-aspeed-i2c-add-properties-for-setting-i2.patch \
    file://0012-i2c-aspeed-update-ast2400-timing-settings.patch \
    file://0013-i2c-add-a-slave-backend-to-receive-and-queue-message.patch \
    file://0014-i2c-aspeed-add-i2c-slave-inactive-timeout-support.patch \
    file://0015-dt-add-pcc-config.patch \
    file://0017-net-ncsi-add-no-channel-monitor-start-redo-probe.patch \
    file://0018-net-ncsi-specify-maximum-package-to-probe.patch \
    file://0019-dmaengine-aspeed-Add-AST2600-UART-DMA-driver.patch \
    file://0020-serial-8250-Add-AST2600-UART-driver.patch \
    file://0021-mmc-sdhci-of-aspeed-add-skip_probe-module-parameter.patch \
    file://0022-drivers-hwmon-MCP9600-temperature-driver.patch \
    file://0023-drivers-hwmon-i3c-apml-driver.patch \
    file://0025-drivers-soc-add-Aspeed-OTP-control-register.patch \
    file://0026-drivers-soc-add-Aspeed-Post-Code-Control.patch \
    "
