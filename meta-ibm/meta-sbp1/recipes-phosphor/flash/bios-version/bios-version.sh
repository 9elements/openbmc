#!/bin/bash
set -e

IPMB_OBJ="xyz.openbmc_project.Ipmi.Channel.Ipmb"
IPMB_PATH="/xyz/openbmc_project/Ipmi/Channel/Ipmb"
IPMB_INTF="org.openbmc.Ipmb"

power_status() {
    st=$( (busctl get-property xyz.openbmc_project.State.Chassis /xyz/openbmc_project/state/chassis0 xyz.openbmc_project.State.Chassis CurrentPowerState || echo "off") | cut -d"." -f6 )
    if [ "$st" == "On\"" ]; then
        echo "on"
    else
        echo "off"
    fi
}

me_wait_poweron() {
    echo "Wait for SPS firmware to start"
    # shellcheck disable=SC2034
    for i in {1..10}; do
      # me address, 0x6 App Fn, 0x00 - lun, 0x1 - get device id
      if ! busctl call --timeout=1 "$IPMB_OBJ" "$IPMB_PATH" "$IPMB_INTF" sendRequest yyyyay 1 6 0 0x1 0 2>/dev/null; then
        sleep 1
      else
        break
      fi
    done

    # me address, 0x6 App Fn, 0x00 - lun, 0x1 - get device id
    if ! busctl call --timeout=1 "$IPMB_OBJ" "$IPMB_PATH" "$IPMB_INTF" sendRequest yyyyay 1 6 0 0x1 0 2>/dev/null; then
      echo "Failed to communicate with SPS firmware"
      exit 1
    fi
}

CHASSIS_STATUS=$(power_status)
if [ "$CHASSIS_STATUS" == "on" ]; then
  me_wait_poweron

  BIOS_FILE="$(mktemp)"
  flashrom -p linux_mtd:dev=12 --ifd -i bios -r "${BIOS_FILE}"

  bios_version=$(strings "${BIOS_FILE}" | grep COREBOOT_EXTR | head -n 1 | awk '{ print $3}' | sed 's/"//g')

  if [ "${bios_version}" == "" ] ; then
    bios_version=$(strings "${BIOS_FILE}" | grep COREBOOT_VERS | head -n 1 | awk '{ print $3}' | sed 's/"//g')
  fi
  rm "${BIOS_FILE}"

  if [ "${bios_version}" != "" ] ; then
    if [ -f /var/cache/bios_version ] ; then
      rm /var/cache/bios_version
    fi

    echo "coreboot-${bios_version}" > /var/cache/bios_version
  fi
fi

if [ -f /var/cache/bios_version ] ; then
  busctl set-property xyz.openbmc_project.Software.BMC.Updater \
      /xyz/openbmc_project/software/bios_active \
      xyz.openbmc_project.Software.Version Version s "$(cat /var/cache/bios_version)"
fi
