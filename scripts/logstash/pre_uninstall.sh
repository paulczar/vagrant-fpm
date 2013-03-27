#!/bin/sh

chkconfig logstash off
service logstash stop

rm -f /etc/init.d/logstash
