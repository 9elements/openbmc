#!/bin/sh
echo "Hello from OpenBMC Workshop!" > /etc/motd
echo "Hello service executed at $(date)" >> /var/log/workshop.log
exit 0
