PROJECT_NAME = "magento-php7"
IP = "10.10.10.8"
NFS_EXPORT = true

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network :private_network, ip: IP
  config.ssh.forward_agent = true

  config.nfs.map_uid = Process.uid
  config.nfs.map_gid = Process.gid
  if RUBY_PLATFORM =~ /linux/
          config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", type: "rsync", rsync__exclude: ["htdocs/.git/",".idea/","htdocs/var/","./.modman/","./vendor/","./config/","./db/"], rsync__args: ["--verbose", "--archive","-z"]
          config.vm.synced_folder "vendor", "/vagrant/vendor", id:"vendor-root", type: "nfs"
          config.vm.synced_folder ".modman", "/vagrant/.modman", id:"modman-root", type: "nfs"
          config.vm.synced_folder "config", "/vagrant/config", id:"config", type: "nfs"
          config.vm.synced_folder "db", "/vagrant/db", id:"db", type: "nfs"
    elsif RUBY_PLATFORM =~ /darwin/
        config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", type: "rsync", rsync__exclude: ["htdocs/.git/",".idea/","htdocs/var/","./.modman/","./vendor/","./config/","./db/"], rsync__args: ["--verbose", "--archive","-z"]
        config.vm.synced_folder "vendor", "/vagrant/vendor", id:"vendor-root", :nfs => { :mount_options => ["dmode=777","fmode=777"] }
        config.vm.synced_folder ".modman", "/vagrant/.modman", id:"modman-root", :nfs => { :mount_options => ["dmode=777","fmode=777"] }
        config.vm.synced_folder "config", "/vagrant/config", id:"config", :nfs => { :mount_options => ["dmode=777","fmode=777"] }
        config.vm.synced_folder "db", "/vagrant/db", id:"db", :nfs => { :mount_options => ["dmode=777","fmode=777"] }
     elsif RUBY_PLATFORM =~ /win32/
          config.vm.synced_folder ".","/vagrant", id:"vagrant-root"
     end

  # Set the virtual machine host name
  config.vm.hostname = PROJECT_NAME + ".local"


  config.vm.provision :shell, :inline => "echo \"CET\" |
    sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--name", PROJECT_NAME]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--vram", 64]
    v.customize ["modifyvm", :id, "--cpus", "1"]
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
  end

  config.vm.provision "shell", inline: "chmod +x /vagrant/bin/*.sh"
  ## Uncomment the next line to provision a new magneto vm
  config.vm.provision "shell", inline: "/vagrant/bin/vagrant_up.sh"
  #, run: "always"
  config.vm.provision "shell", inline: "service nginx restart", run: "always"
end
