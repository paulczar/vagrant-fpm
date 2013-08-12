#!/bin/bash -x

VERSION=2.6.11
PREFIX=/

cd /tmp
curl  -L -k http://redis.googlecode.com/files/redis-$VERSION.tar.gz| tar -xz
cd redis-$VERSION
make
# should probably run the test ....
#make test

mkdir -p /tmp/build-redis-$VERSION/$PREFIX/usr/bin
mkdir -p /tmp/build-redis-$VERSION/$PREFIX/etc/init.d
mkdir -p /tmp/build-redis-$VERSION/$PREFIX/etc/redis

cp src/{redis-benchmark,redis-check-aof,redis-check-dump,redis-cli,redis-server} /tmp/build-redis-$VERSION/$PREFIX/usr/bin

if [ -e /etc/redhat-release ]
then
  RELEASE=$(cat /etc/redhat-release  | awk '{print $1 "-" $3}')
  mkdir -p /vagrant/pkg/$RELEASE
  cd /vagrant/pkg/$RELEASE
  fpm -s dir -t rpm -n redis -v $VERSION -C /tmp/build-redis-$VERSION/ .
fi

if [ -e /etc/lsb-release ]
then
  RELEASE=$(lsb_release -c | awk '{print $2}')
  mkdir -p /vagrant/pkg/$RELEASE
  cd /vagrant/pkg/$RELEASE
  fpm -s dir -t deb -n redis -v $VERSION -C /tmp/build-redis-$VERSION/ .
fi

echo "Your package is in /vagrant/pkg/$RELEASE"
echo "Please note it contains no config file or init script ... use Puppet/Chef."