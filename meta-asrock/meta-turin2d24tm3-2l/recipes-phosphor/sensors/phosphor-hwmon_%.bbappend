FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Sensor chip definitions for TURIN2D24TM3-2L
# Using actual I2C device paths that will be created by the kernel
CHIPS:turin2d24tm3-2l = " \
               bus/i2c-2/2-004c \
               bus/i2c-3/3-0048 \
               bus/i2c-6/6-0061 \
               bus/i2c-6/6-0062 \
               bus/i2c-6/6-0063 \
               bus/i2c-6/6-0072 \
               bus/i2c-6/6-0074 \
               bus/i2c-6/6-0075 \
               bus/i2c-7/7-004c \
               bus/i2c-11/11-004c \
               "

# Format paths to configuration files
ITEMSFMT:turin2d24tm3-2l = "ahb/apb/{0}.conf"
ITEMS:turin2d24tm3-2l = "${@compose_list(d, 'ITEMSFMT', 'CHIPS')}"

# Add ADC/iio-hwmon configuration
ITEMS:append:turin2d24tm3-2l = " iio_hwmon.conf"

# Add all items to systemd environment
ENVS = "obmc/hwmon/{0}"
SYSTEMD_ENVIRONMENT_FILE:${PN}:append:turin2d24tm3-2l = " ${@compose_list(d, 'ENVS', 'ITEMS')}"
