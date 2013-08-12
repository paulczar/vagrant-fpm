# vagrant-fpm

Vagrant skeleton for building packages with FPM.

## Installing

`set_os` is a script to tell vagrant which OS you want to boot.  It includes a default set of boxes that have been
tested as working.   Update it include your own boxes if you don't want to use the defaults.

* Ubuntu variants will install Ruby 1.9.3, Build-Essentials and FPM
* Rhel/CentOS variants will monkeypatch FPM into the Chef's Ruby in /opt/chef/embedded.  This helps workaround the fact that ruby is painful to deal with on RHEL boxes.


```
git clone https://github.com/paulczar/vagrant-fpm.git
cd vagrant-fpm
source ./set_os [centos5,centos6,precise,raring]
vagrant up
vagrant ssh
```
FPM and all required packages should be installed by provisioning.

## Creating Packages

run `/vagrant/scripts/redis/make_package.sh` for example script to create redis rpm

rpms should be built in /vagrant/pkg/ for ease of access.


