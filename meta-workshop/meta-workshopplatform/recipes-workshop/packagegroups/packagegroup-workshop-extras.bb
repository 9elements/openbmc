SUMMARY = "Workshop Specific Packages"
PR = "r1"

inherit packagegroup

PACKAGES = " \
    ${PN} \
"

RDEPENDS:${PN} = " \
    entity-manager \
    hello-service \
    hello-cpp \
    sensor-history \
"
