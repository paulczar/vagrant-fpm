#!/bin/bash -x

VERSION=1.1.9
LS_DIR=/opt/logstash

yum -y install java-1.7.0-openjdk.x86_64

# Make Skeleton

mkdir $LS_DIR
mkdir -p $LS_DIR/{bin,conf.d,data,log} # /opt/logstash/conf.d /opt/logstash/data /opt/logstash/log

# Logstash

cd $LS_DIR/bin
wget --no-check-certificate https://logstash.objects.dreamhost.com/release/logstash-$VERSION-monolithic.jar
mv logstash-$VERSION-monolithic.jar logstash-monolithic.jar

cp -av /vagrant/scripts/logstash/logstash.init /etc/init.d/logstash
chmod 755 /etc/init.d/logstash

mkdir -p /vagrant/rpms
cd /vagrant/rpms

fpm -s dir -t rpm -d 'java-1.7.0-openjdk' --post-install "/vagrant/scripts/logstash/post_install.sh" \
                --pre-uninstall "/vagrant/scripts/logstash/pre_uninstall.sh" -n "logstash" -v $VERSION $LS_DIR

