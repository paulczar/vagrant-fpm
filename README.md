# vagrant-fpm

Vagrant skeleton for building packages with FPM.

## Requirements

### Vagrant 1.2.1 +

* Ruby 1.9.3 ( may work with older versions )
* Vagrant - http://downloads.vagrantup.com/

* Vagrant Plugins
** vagrant-omnibus     `vagrant plugin install vagrant-omnibus`
** vagrant-berkshelf   `vagrant plugin install vagrant-berkshelf`
** vagrant-cachier     `vagrant plugin install vagrant-cachier`

## Installing

`set_os` is a script to tell vagrant which OS you want to boot.  It includes a default set of boxes that have been
tested as working.   Update it include your own boxes if you don't want to use the defaults.

* Ubuntu variants will install Ruby 1.9.3, Build-Essentials and FPM
* Rhel/CentOS variants will monkeypatch FPM into the Chef's Ruby in /opt/chef/embedded.  This helps workaround the fact that ruby is painful to deal with on RHEL boxes.  Also installs Build-Essentials and rpm-build.

```
git clone https://github.com/paulczar/vagrant-fpm.git
cd vagrant-fpm
source ./set_os [centos5,centos6,precise,raring]
vagrant up
vagrant ssh
```

## Creating Packages

Example script for building redis packages.

```
source ./set_os centos5
vagrant up
/vagrant/scripts/redis/make_package.sh`
```


rpms should be built in /vagrant/pkg/ for ease of access.


