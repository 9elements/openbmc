#!/bin/sh

while true; do
    sleep 5
    /usr/sbin/logrotate /etc/logrotate.d/logrotate.rsyslog
    ec=$?
    if [ $ec -ne 0 ] ; then
        echo "logrotate failed ($ec)"
    fi
done
