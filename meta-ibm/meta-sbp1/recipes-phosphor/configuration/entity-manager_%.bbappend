FILESEXTRAPATHS:prepend:sbp1 := "${THISDIR}/${PN}:"

SRC_URI = "git://github.com/9elements/entity-manager.git;branch=sbp1;protocol=https \
           file://blocklist.json \
          "
SRC_URI[sha256sum] = "f561e5a70eaeb880387036de1353751606b6f98b2dafb52bf3c03025a5fa126d"

SRCREV = "1b9c0918ab19e7b0281b6d470e06730601191064"

SRC_URI:append:sbp1 = " \
    file://blacklist.json \
    file://sbp1-cpu-dimms.json \
"

do_install:append:sbp1 () {
    install -m 0644 -D ${WORKDIR}/blacklist.json ${D}${datadir}/${PN}/blacklist.json
    install -d ${D}/usr/share/entity-manager/configurations
    install -m 0444 ${WORKDIR}/sbp1-cpu-dimms.json ${D}/usr/share/entity-manager/configurations
}
