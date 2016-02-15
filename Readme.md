## Vagrant + Magento (1.9.2.3) + PHP-7.0.0

This Vagrantbox will build a Virtual Server for Virtualbox based on Ubuntu 14.04.
On 'vagrant up' it will automatically install a Stack based on the following:

* Nginx (1.4.6-1ubuntu3.3)
* MySQL-Server 5.6
* PHP7.0.0 (compiled from source)

## Installation
To get it up and running follow the steps:

* Download and install [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* Download and install [Vagrant](https://www.vagrantup.com/downloads.html)
* Make sure you are at least at Vagrant version 1.5 or the steps below may not work for you.
* change parameters in Vagrantfile
* change parameters in config/settings/nginx/default

Execute

    $ php composer.phar install
    $ vagrant up

After successful first build you should disable line: 3 in ./bin/vagrant_up.sh to avoid the installation runs on every vagrant up.

    #/vagrant/bin/vagrant-bootstrap.sh


### What it does:

* Build the virtual Server
* on composer install will Magento installed
* import install.sql.gz from "db" folder

### Information:
MySQL-Root Password: empty (really empty "" not the string empty)
PHP-7 is installed in /usr/local/php7

To Sync the changes in htdocs folder a `vagrant rsync` must be executed

###Caution:
~~One thing has to be changed, to get it to work.(TODO:write a Module)~~

~~File htdocs/app/code/core/Mage/Core/Model/Layout.php:555~~

Fixed with a Module :thumbsup:

### Author
Roman Hutterer
[CopeX.io](https://copex.io)
