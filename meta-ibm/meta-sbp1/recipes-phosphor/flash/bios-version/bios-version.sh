#!/bin/bash

chassis_turned_on=0

if ! [ -f /var/cache/bios_version ] ; then

  while :
  do
    obmcutil status | grep Chassis.PowerState

    if [ $? -eq 0 ] ; then
      break;
    fi

    sleep 5;
  done

  obmcutil status | grep Chassis | grep Off
  if [ $? -eq 0 ]; then
    obmcutil chassison
    chassis_turned_on=1
    sleep 10
  fi

  dd if=/dev/mtd/aspeed-espi-ctrl of=/tmp/bios.bin || \
  dd if=/dev/mtd/aspeed-espi-ctrl of=/tmp/bios.bin

  bios_version=$(strings /tmp/bios.bin | grep COREBOOT_EXTR | head -n 1 | awk '{ print $3}' | sed 's/"//g')

  if [ "$bios_version" == "" ] ; then
    bios_version=$(strings /tmp/bios.bin | grep COREBOOT_VERS | head -n 1 | awk '{ print $3}' | sed 's/"//g')
  fi
  rm /tmp/bios.bin

  bios_version="coreboot-${bios_version}"
  echo $bios_version > /var/cache/bios_version

else

  bios_version=$(cat /var/cache/bios_version)

fi

busctl set-property  xyz.openbmc_project.Software.BMC.Updater /xyz/openbmc_project/software/bios_active xyz.openbmc_project.Software.Version Version s $bios_version


if [ $chassis_turned_on -eq 1 ] ; then
  obmcutil chassisoff
fi

