FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"
OBMC_CONSOLE_HOST_TTY = "ttyS2"

SRC_URI:remove = " file://${BPN}.conf "
SRC_URI:append = " file://server.ttyS2.conf "
SRC_URI:append = " file://dropbear.env "

do_install:append() {
        # Install the server configuration
        install -m 0755 -d ${D}${sysconfdir}/${BPN}

        install -m 0644 ${WORKDIR}/*.conf ${D}${sysconfdir}/${BPN}/
        #install -m 0644 ${WORKDIR}/dropbear.envfile ${D}${sysconfdir}/${BPN}/

        # Remove upstream-provided server configuration
        rm -f ${D}${sysconfdir}/${BPN}/server.ttyVUART0.conf
}

