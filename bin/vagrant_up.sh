#!/bin/bash

 /vagrant/bin/vagrant-bootstrap.sh
#
cd /vagrant/
#
if [ ! -e htdocs/app/etc/local.xml ]; then #Install Magento Database
    echo "Installing Magento"
    #Create Database
    mysqladmin -uroot create magento
    if [ -e config/local.xml ]; then #symlink local.xml from config
        echo "Symlinking local.xml"
        ln -fs /vagrant/config/local.xml /vagrant/htdocs/app/etc/local.xml
    else
        #Create DB Config (n98)
        echo "Creating local.xml"
        sudo -u vagrant -H sh -c "bin/n98-magerun --root-dir=htdocs local-config:generate localhost root '' magento db backoffice"
        cp htdocs/app/etc/local.xml config/local.xml
    fi
    #Import Database if possible
    if [ -e db/install.sql.gz ]; then
        echo "Importing Database from db/install.sql.gz"
        bin/n98-magerun --root-dir=htdocs db:import -c gzip /vagrant/db/install.sql.gz
    else
        echo "Creating admin user"
        bin/n98-magerun --root-dir=htdocs admin:user:create admin admin@admin.info admin123 Admini Strator Administrators
    fi

    # Write permissions in media
    chmod -R 0770 htdocs/media

    # Now after Magento has been installed, deploy all additional modules and run setup scripts
    sudo -u vagrant -H sh -c "bin/modman deploy-all --force > /dev/null"
    bin/n98-magerun --root-dir=htdocs sys:setup:run

    # Set up PHPUnit
    ln -fs /vagrant/config/local.xml.phpunit /vagrant/htdocs/app/etc/local.xml.phpunit
    mysqladmin -uroot create magento_unit_tests
    if [ -e /vagrant/htdocs/shell/ecomdev-phpunit-install.php ]; then
		echo "Creating phpUnit test database"
		php /vagrant/htdocs/shell/ecomdev-phpunit-install.php
    fi

    bin/n98-magerun --root-dir=htdocs config:set dev/log/active 1
    bin/n98-magerun --root-dir=htdocs config:set dev/template/allow_symlink 1
fi
