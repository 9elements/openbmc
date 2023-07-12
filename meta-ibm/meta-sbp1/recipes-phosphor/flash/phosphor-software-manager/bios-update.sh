#!/bin/bash

set -e

IMAGE_FILE=$(find $1 -name "*.FD")

IPMB_OBJ="xyz.openbmc_project.Ipmi.Channel.Ipmb"
IPMB_PATH="/xyz/openbmc_project/Ipmi/Channel/Ipmb"
IPMB_INTF="org.openbmc.Ipmb"
IPMB_CALL="sendRequest yyyyay"


# me address, 0x2e oen, 0x00 - lun, 0xdf - force recovery
ME_CMD_RECOVER="1 0x2e 0 0xdf 4 0x57 0x01 0x00 0x01"
# me address, 0x6 App Fn, 0x00 - lun, 0x2 - cold reset
ME_CMD_RESET="1 6 0 0x2 0"
# me address, 0x6 App Fn, 0x00 - lun, 0x1 - get device id
ME_GET_DEVICE_ID="1 6 0 0x1 0"

echo "Bios upgrade started at $(date)"

#Power off host server.
echo "Power off host server"
busctl set-property xyz.openbmc_project.State.Host0 /xyz/openbmc_project/state/host0 xyz.openbmc_project.State.Host RequestedHostTransition s "xyz.openbmc_project.State.Host.Transition.Off"
echo "Host server powered off"

sleep 1

echo "Power on PCH"
busctl set-property xyz.openbmc_project.State.Chassis /xyz/openbmc_project/state/chassis0 xyz.openbmc_project.State.Chassis RequestedPowerTransition s "xyz.openbmc_project.State.Chassis.Transition.On"
echo "PCH is powered on"

for i in {1..10}; do
  st=$(busctl get-property xyz.openbmc_project.State.Chassis /xyz/openbmc_project/state/chassis0 xyz.openbmc_project.State.Chassis CurrentPowerState | cut -d"." -f6)
  if [ "$st" == "On\"" ]; then
    break
  else
    sleep 1
  fi
done

if [ "$st" != "On\"" ]; then
  echo "Failed to power on PCH"
  exit 1
fi

echo "Wait for ME firmware to start"
for i in {1..10}; do
  if ! busctl call --timeout=1 "$IPMB_OBJ" "$IPMB_PATH" "$IPMB_INTF" $IPMB_CALL $ME_GET_DEVICE_ID 2>/dev/null; then
    sleep 1
  else
    break
  fi
done

if ! busctl call --timeout=1 "$IPMB_OBJ" "$IPMB_PATH" "$IPMB_INTF" $IPMB_CALL $ME_GET_DEVICE_ID 2>/dev/null; then
  echo "Failed to communicate with SPS firmware"
  exit 1
fi

#Set ME to recovery mode
echo "Set ME to recovery mode"
# shellcheck disable=SC2086
busctl call "$IPMB_OBJ" "$IPMB_PATH" "$IPMB_INTF" $IPMB_CALL $ME_CMD_RECOVER

# Enable FM_FLASH_SEC_OVRD
gpioset $(gpiofind FM_FLASH_SEC_OVRD)=1

#Flashcp image to device.
if [ -e "$IMAGE_FILE" ];
then
    echo "Bios image is $IMAGE_FILE"
    flashrom -p linux_mtd:dev=12 -w $IMAGE_FILE
else
    echo "Bios image $IMAGE_FILE doesn't exist"
fi

# Disable FM_FLASH_SEC_OVRD
gpioset $(gpiofind FM_FLASH_SEC_OVRD)=0

#Reset ME to boot from new bios
echo "Reset ME to boot from new bios"
# shellcheck disable=SC2086
busctl call "$IPMB_OBJ" "$IPMB_PATH" "$IPMB_INTF" $IPMB_CALL $ME_CMD_RESET
sleep 5

busctl set-property xyz.openbmc_project.State.Chassis /xyz/openbmc_project/state/chassis0 xyz.openbmc_project.State.Chassis RequestedPowerTransition s xyz.openbmc_project.State.Chassis.Transition.Off

# Delete cached bios version file if it exist.
rm /var/cache/bios_version || true
