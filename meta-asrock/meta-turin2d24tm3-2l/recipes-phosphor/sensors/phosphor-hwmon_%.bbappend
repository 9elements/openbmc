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

# Add PWM fan devices - simple names without @ to avoid systemd encoding issues
# PWM fans are at /sys/devices/platform/pwmfans/pwmfans:fanX/hwmon/hwmonN/
# Device tree path is pwmfans/fanX (kernel adds colon prefix)
# Config files named after DT path: pwmfans/fanX.conf
PWM_FAN_CHIPS:turin2d24tm3-2l = " \
               fan0 \
               fan1 \
               fan2 \
               fan3 \
               fan4 \
               fan5 \
               fan6 \
               fan7 \
               "

# Format PWM fan config paths (no ahb/apb prefix, no parent device prefix)
PWM_ITEMSFMT:turin2d24tm3-2l = "pwmfans/{0}.conf"
PWM_ITEMS:turin2d24tm3-2l = "${@compose_list(d, 'PWM_ITEMSFMT', 'PWM_FAN_CHIPS')}"

# Add PWM fan configs directly to ITEMS (not via CHIPS to avoid ahb/apb prefix)
ITEMS:append:turin2d24tm3-2l = " ${PWM_ITEMS}"

# Add all items to systemd environment
ENVS = "obmc/hwmon/{0}"
SYSTEMD_ENVIRONMENT_FILE:${PN}:append:turin2d24tm3-2l = " ${@compose_list(d, 'ENVS', 'ITEMS')}"
