FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Fix HW_SENSOR_ID generation to remove spaces around equals sign
# This is required for systemd EnvironmentFile format
pkg_postinst:${PN}() {
    hwmon_dir="$D/etc/default/obmc/hwmon"
    dbus_dir="$D/${datadir}/dbus-1/system.d"
    if [ -n "$D" -a -d "${hwmon_dir}" ]; then
        # Remove existing links and replace with actual copy of the file to prevent
        # HW_SENSOR_ID variable override for different sensors' instances.
        find "${hwmon_dir}" -type l -name \*.conf | while read f; do
            path="$(readlink -f $f)"
            rm -f "${f}"
            cp "${path}" "${f}"
        done
        find "${hwmon_dir}" -type f -name \*.conf | while read f; do
            path="/${f##${hwmon_dir}/}"
            path="${path%.conf}"
            sensor_id="$(printf "%s" "${path}" | sha256sum | cut -d\  -f1)"
            acl_file="${dbus_dir}/xyz.openbmc_project.Hwmon-${sensor_id}.conf"
            egrep -q '^HW_SENSOR_ID\s*=' "${f}" ||
                printf "\n# Sensor id for %s\nHW_SENSOR_ID=\"%s\"\n" "${path}" "${sensor_id}" >> "${f}"
            # Extract HW_SENSOR_ID that could be either quoted or unquoted string.
            sensor_id="$(sed -n 's,^HW_SENSOR_ID\s*=\s*"\?\(.[^" ]\+\)\s*"\?,\1,p' "${f}")"
            [ ! -f "${acl_file}" ] || continue
            path_s="$(echo "${path}" | sed 's,\-\-,\\-\\-,g')"
            cat <<EOF>"${acl_file}"
<!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>
  <policy user="root">
    <!-- ${path_s} -->
    <allow own="xyz.openbmc_project.Hwmon-${sensor_id}.Hwmon1"/>
    <allow send_destination="xyz.openbmc_project.Hwmon-${sensor_id}.Hwmon1"/>
  </policy>
</busconfig>
EOF
        done
    fi
}
