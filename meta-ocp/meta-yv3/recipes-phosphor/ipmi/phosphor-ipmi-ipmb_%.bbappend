FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
  file://ipmb-channels.json \
  file://0001-debug-buffer-sent.patch \
"

do_install:append(){
    install -m 0644 -D ${WORKDIR}/ipmb-channels.json \
                   ${D}${datadir}/ipmbbridge/
}

#IPMB_CHANNELS = "\
#    /dev/ipmb-0 
#    /dev/ipmb-1 
#    /dev/ipmb-2 
#    /dev/ipmb-3 
#    /dev/ipmb-9 
#    "

