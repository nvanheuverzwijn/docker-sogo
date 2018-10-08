#!/bin/bash

sed -i 's|SYSLOG_OPTS="-C128"|SYSLOG_OPTS="-C128 -O /dev/null"|' /etc/default/busybox-syslogd

service busybox-syslogd start > /dev/null
logread -f &
