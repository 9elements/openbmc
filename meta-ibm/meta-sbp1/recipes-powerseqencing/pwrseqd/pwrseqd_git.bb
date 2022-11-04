SUMMARY = "Power sequencing daemon"
DESCRIPTION = "universal userspace powerseqencing, fault handling and ACPI state tracking"
HOMEPAGE = "https://9esec.io"
BUGTRACKER = "https://github.com/9elements/pwrseqd/issues"
SECTION = "base"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=3b83ef96387f14655fc854ddc3c6bd57"

BRANCH = "main"
SRC_URI = "gitsm://github.com/9elements/pwrseqd.git;branch=${BRANCH};protocol=https"
SRCREV = "3d35ffe5ed4bc9927619494b399b1b5ca7fb8442"

S = "${WORKDIR}/git"

inherit cmake systemd pkgconfig

DEPENDS += "systemd"
DEPENDS += "boost"
DEPENDS += "libgpiod"
DEPENDS += "libyaml"
DEPENDS += "yaml-cpp"
DEPENDS += "sdbusplus"
DEPENDS += "phosphor-logging"

EXTRA_OECMAKE = "\
                 -DBUILD_TESTS=OFF \
                 -DBUILD_EXAMPLE=OFF \
                 "

SYSTEMD_SERVICE:${PN} += "xyz.openbmc_project.Chassis.Control.Power@${MACHINE}.service \
                          chassis-system-reset.service \
                          chassis-system-reset.target"

FILES:${PN}  += "${systemd_system_unitdir}/xyz.openbmc_project.Chassis.Control.Power@.service"
FILES:${PN}  += "${systemd_system_unitdir}/chassis-system-reset.service"
FILES:${PN}  += "${systemd_system_unitdir}/chassis-system-reset.target"
