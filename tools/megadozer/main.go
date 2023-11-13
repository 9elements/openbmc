package main

import (
	"log"
	"os"
	"os/exec"
	"syscall"

	_ "embed"

	"github.com/facebook/openbmc/tools/flashy/lib/flash/flashcp"
)

//go:embed flash.img
var img []byte

func main() {
	log.Println("Writing out obmc image...")
	if err := os.WriteFile("/var/obmc.img", img, 0o666); err != nil {
		log.Fatalf("Failed to write image: %v", err)
	}

	log.Println("Remounting flash as read-only...")
	c := exec.Command("echo", "u", ">", "/proc/sysrq-trigger")
	if err := c.Run(); err != nil {
		log.Fatalf("Failed to remount rootfs: %v", err)
	}

	log.Println("Overwriting flash contents...")
	if err := flashcp.FlashCp("/var/obmc.img", "/dev/mtd0", 0); err != nil {
		log.Fatalf("Failed to overwrite flash: %v", err)
	}

	log.Println("Resetting system now...")
	if err := syscall.Reboot(syscall.LINUX_REBOOT_CMD_RESTART); err != nil {
		log.Fatalf("Failed to reboot machine: %v", err)
	}
}
