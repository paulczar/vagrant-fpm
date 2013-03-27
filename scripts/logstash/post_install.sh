#!/bin/bash -x

cp -av /vagrant/scripts/logstash/logstash.init /etc/init.d/logstash
chmod 755 /etc/init.d/logstash
