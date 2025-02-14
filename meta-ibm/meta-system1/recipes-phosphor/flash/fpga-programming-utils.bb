SUMMARY = "FPGA Programming Utility"
LICENSE = "CLOSED"
SRC_URI = "file://get_fpga_rev.sh \
           file://i2cupdate"

S = "${UNPACKDIR}"

do_install:append() {
    install -d ${D}${sbindir}
    install -m 0755 ${UNPACKDIR}/get_fpga_rev.sh ${D}${sbindir}/
    install -m 0755 ${UNPACKDIR}/i2cupdate ${D}${sbindir}/
}

FILES:${PN} += "${sbindir}/get_fpga_rev.sh ${sbindir}/i2cupdate"
RDEPENDS:${PN} += "bash"
