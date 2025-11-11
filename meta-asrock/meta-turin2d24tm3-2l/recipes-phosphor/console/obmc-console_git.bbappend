FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Use VUART (Virtual UART over LPC) for host serial console
SRC_URI:append:turin2d24tm3-2l = " file://server.ttyVUART0.conf"
