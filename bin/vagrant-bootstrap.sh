#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# /tmp has to be world-writable, but sometimes isn't by default.
chmod 0777 /tmp

# copy ssh key
cp -r /vagrant/.ssh/* /home/vagrant/.ssh/
chmod 0600 /home/vagrant/.ssh/*
chown vagrant:vagrant /home/vagrant/.ssh/*



# PHP 5.5 from PPA
apt-get update
apt-get install -y python-software-properties
# Add Mysql 5.6
#add-apt-repository -y ppa:ondrej/mysql-5.6


# Add PHP7
apt-get install -y git-core autoconf bison libxml2-dev libbz2-dev libmcrypt-dev libcurl4-openssl-dev libltdl-dev libpng-dev libpspell-dev libreadline-dev
mkdir -p /etc/php7/conf.d
mkdir -p /etc/php7/cli/conf.d
mkdir /usr/local/php7

cd /tmp
wget https://github.com/php/php-src/archive/php-7.0.0.tar.gz
tar xzf php-7.0.0.tar.gz
cd php-src-php-7.0.0

./buildconf --force
./configure --prefix=/usr/local/php7 --without-pear --enable-opcache-file --enable-fpm --with-mysql-sock=/var/run/mysqld/mysqld.sock --enable-bcmath --with-bz2 --enable-calendar --enable-exif --enable-dba --enable-ftp --with-gettext --with-gd --enable-mbstring --with-mcrypt --with-mhash --enable-mysqlnd --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-openssl --enable-pcntl --with-pspell --enable-shmop --enable-soap --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx --with-zlib --enable-zip --with-readline --with-curl --with-config-file-path=/etc/php7/cli --with-config-file-scan-dir=/etc/php7/cli/conf.d
#simple fast way to replace pear protocol to http cause they haven't a valid ssl-cert
sed -i 's/https:\/\/pear.php.net\/install-pear-nozlib.phar/http:\/\/pear.php.net\/install-pear-nozlib.phar/g' Makefile
make
#make test
make install


#copy config files
ln -fs /vagrant/config/settings/php/php-fpm.conf /usr/local/php7/etc/php-fpm.conf
ln -fs /vagrant/config/settings/php/www.conf /usr/local/php7/etc/php-fpm.d/www.conf

#configure for use as php-fpm service
ln -fs /vagrant/config/settings/php/php7-fpm /etc/init.d/php7-fpm
chmod 0755 /etc/init.d/php7-fpm
/usr/lib/insserv/insserv php7-fpm

ln -fs /vagrant/config/settings/php/php7-fpm.service /lib/systemd/system/php7-fpm.service
service php7-fpm start

cd /usr/bin
ln -s /usr/local/php7/bin/php

# Required packages
apt-get -q -y install mysql-server
apt-get install -y libnss-mdns curl git libssl0.9.8 sendmail language-pack-de-base vim
apt-get install -y nginx

# xDebug
#apt-get install php5-xdebug
#ln -s /vagrant/config/settings/xdebug.ini /etc/php5/fpm/conf.d/21-xdebug-extra.ini

#Set up Git interface: use colors, add "git tree" command
git config --global color.ui true
git config --global alias.tree "log --oneline --decorate --all --graph"

# Composer
#curl -sS https://getcomposer.org/installer | php
#mv composer.phar /usr/local/bin/composer

# Modman
#curl -s -o /usr/local/bin/modman https://raw.githubusercontent.com/colinmollenhour/modman/master/modman
#chmod +x /usr/local/bin/modman

# n98-magerun
#curl -s -o /usr/local/bin/n98-magerun https://raw.githubusercontent.com/netz98/n98-magerun/master/n98-magerun.phar
#chmod +x /usr/local/bin/n98-magerun

# make Magento directories writable as needed and add www-data user to vagrant group
chmod -R 0777 /vagrant/htdocs/var /vagrant/htdocs/app/etc /vagrant/htdocs/media
usermod -a -G vagrant www-data
usermod -a -G www-data vagrant


# MySQL configuration, cannot be linked because MySQL refuses to load world-writable configuration
cp -f /vagrant/config/settings/my.cnf /etc/mysql/my.cnf
service mysql restart
# Allow access from host
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'; FLUSH PRIVILEGES;"

# Set locale
ln -fs /vagrant/config/settings/locale /etc/default/locale


ln -fs /vagrant/config/settings/nginx/default /etc/nginx/sites-available/default
service nginx reload
