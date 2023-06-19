FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

EXTRA_OEMESON:append:sbp1 = " \
  -Dupdate-functional-on-fail=true \
  -Dnegative-errno-on-fail=false \
"

ITEMS:append:sbp1 = " iio-hwmon-rtcbat.conf"
ITEMS:append:sbp1 = " iio-hwmon-fan-ssbs.conf"
ITEMS:append:sbp1 = " iio-hwmon-m2-ssb.conf"
ITEMS:append:sbp1 = " iio-hwmon-pch-ssb.conf"
ITEMS:append:sbp1 = " iio-hwmon-rssbs.conf"
ITEMS:append:sbp1 = " thermal-sensor0.conf"
ITEMS:append:sbp1 = " thermal-sensor1.conf"
ITEMS:append:sbp1 = " thermal-sensor2.conf"
ITEMS:append:sbp1 = " thermal-sensor3.conf"

ENVS = "obmc/hwmon/{0}"
SYSTEMD_ENVIRONMENT_FILE:${PN}:append:sbp1 = " ${@compose_list(d, 'ENVS', 'ITEMS')}"