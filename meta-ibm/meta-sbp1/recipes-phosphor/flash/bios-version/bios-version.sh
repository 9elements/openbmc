#!/bin/bash

if ! [ -f /var/cache/bios_version ] ; then

  while :
  do
    obmcutil status | grep Chassis.PowerState

    if [ $? -eq 0 ] ; then
      break;
    fi

    sleep 5;
  done

  # Enable FM_FLASH_SEC_OVRD
  gpioset $(gpiofind FM_FLASH_SEC_OVRD)=1

  obmcutil status | grep Chassis | grep On
  if [ $? -eq 0 ]; then
    obmcutil chassisoff
    sleep 1
  fi
  obmcutil chassison
  sleep 10

  dd if=/dev/mtd/aspeed-espi-ctrl of=/tmp/bios.bin || \
  dd if=/dev/mtd/aspeed-espi-ctrl of=/tmp/bios.bin

  # Disable FM_FLASH_SEC_OVRD
  gpioset $(gpiofind FM_FLASH_SEC_OVRD)=0
  obmcutil chassisoff


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



