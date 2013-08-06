# vagrant-fpm

Vagrant skeleton for building packages with FPM.

## Installing

_CentOS 5.9 provisioning broken right now ... no good upstream centos boxes_

```
git clone https://github.com/paulczar/vagrant-fpm.git
cd vagrant-fpm
source ./set_os [centos59,centos64,precise]
vagrant up
vagrant ssh
```
FPM and all required packages should be installed by provisioning.

## Creating Packages

run `/vagrant/scripts/elasticsearch/create_rpm.sh` for example script to create elasticsearch rpm.
run `/vagrant/scripts/redis/make_rpm.sh` for example script to create redis rpm

rpms should be built in /vagrant/rpms/ for ease of access.


