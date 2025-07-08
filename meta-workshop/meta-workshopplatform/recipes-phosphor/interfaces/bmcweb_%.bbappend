FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

EXTRA_OEMESON:append = " -Dredfish-dump-log=enabled -Dredfish-bmc-journal=enabled -Dredfish-dbus-log=enabled "
