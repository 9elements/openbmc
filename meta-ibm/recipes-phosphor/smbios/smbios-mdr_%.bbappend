FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:append:system1 = " \
    slot-drive-presence \
    " 
