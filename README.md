# vagrant-fpm

Vagrant skeleton for building packages with FPM.

## Installing


```
git clone https://github.com/paulczar/vagrant-fpm.git
cd vagrant-fpm
vagrant up
vagrant ssh
sudo /vagrant/scripts/install-fpm.sh
```
^ didn't script fpm install as I have had vbox break networking too often on first boot

## Creating Packages

run `/vagrant/scripts/elasticsearch/create_rpm.sh` for example script to create elasticsearch rpm.
run `/vagrant/scripts/redis/make_rpm.sh` for example script to create redis rpm

rpms should be built in /vagrant/rpms/ for ease of access.


