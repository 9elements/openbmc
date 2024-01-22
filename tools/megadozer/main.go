package main

import (
	"flag"
	"log"
	"os/exec"
	"syscall"

	"github.com/facebook/openbmc/tools/flashy/lib/flash/flashcp"
)

func main() {
	img := flag.String("image", "/var/obmc.img", "Path to obmc image")
	dev := flag.String("device", "/dev/mtd0", "Path to flash device")
	flag.Parse()

	log.Println("Remounting flash as read-only...")
	c := exec.Command("echo", "u", ">", "/proc/sysrq-trigger")
	if err := c.Run(); err != nil {
		log.Fatalf("Failed to remount rootfs: %v", err)
	}

	log.Println("Overwriting flash contents...")
	if err := flashcp.FlashCp(*img, *dev, 0); err != nil {
		log.Fatalf("Failed to overwrite flash: %v", err)
	}

	log.Println("Resetting system now...")
	if err := syscall.Reboot(syscall.LINUX_REBOOT_CMD_RESTART); err != nil {
		log.Fatalf("Failed to reboot machine: %v", err)
	}
}
