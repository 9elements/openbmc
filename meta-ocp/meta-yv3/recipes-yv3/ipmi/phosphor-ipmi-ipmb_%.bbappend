FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

IPMB_CHANNELS = "\
    /dev/ipmb-0 \
    /dev/ipmb-1 \
    /dev/ipmb-2 \
    /dev/ipmb-3 \
    /dev/ipmb-9 \
    "

#IPMB_REMOTE_ADDR ?= ""

