## Megadozer

Small utility written in Go to replace embedded firmware in-place.
It uses the flashy tool from faceboot/openbmc under the hood to acces raw mtd devices.
The flow is as follows:
* Extract the firmware image from the binary
* Call the Linux SysRq trigger to emergency remount every partition to read-only mode
* Access the raw /dev/mtd0 flash device (unaffected by the SysRq change) using flashcp
* Reboot the live system and wait for the new firmware to boot

### Usage
In order to use the utility, you need to have a working Go environment and a prebuilt static.mtd flash image of OpenBMC for the target platform. If both prerequisites are met, you can build the utility with the following command, assuming an AST2500 with MegaRAC as the target to reflash:
```prompt
cp /path/to/openbmc-flash-image.static.mtd /path/to/megadozer/flash.img
GOOS=linux GOARCH=arm GOARM=5 go build -ldflags="-s -w"
```

This should result in a "megadozer" binary which can be copied to the target for example like this:
```prompt
dd if=megadozer | ssh -t sysadmin@10.93.130.62 dd of=/var/megadozer
```

Now you can connect onto the machine via ssh, and then execute the tool like this:
```prompt
chmod +x /var/megadozer
/var/megadozer
```

Sometimes the machine might need a full ATX power cycle, sometimes it'll just work after the softreset which the tool performs.
