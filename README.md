# vagrant-fpm

Vagrant skeleton for building packages with FPM.

## Installing

`set_os` is a script to tell vagrant which OS you want to boot.  It includes a default set of boxes that have been
tested as working.   Update it include your own boxes if you don't want to use the defaults.

for some reason the yum::epel 404's occasionally on the CentOS5 boxes.   just rerun `vagrant provision` if that happens to you.

```
git clone https://github.com/paulczar/vagrant-fpm.git
cd vagrant-fpm
source ./set_os [centos5,centos6,precise,raring]
vagrant up
vagrant ssh
```
FPM and all required packages should be installed by provisioning.

## Creating Packages

run `/vagrant/scripts/elasticsearch/create_rpm.sh` for example script to create elasticsearch rpm.
run `/vagrant/scripts/redis/make_rpm.sh` for example script to create redis rpm

rpms should be built in /vagrant/rpms/ for ease of access.


