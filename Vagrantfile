# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "honeyfarmer"

  #config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "private_network",
    ip: "192.168.33.10"
  #config.vm.network "public_network",
  #  use_dhcp_assigned_default_route: true
  config.vm.network "forwarded_port", guest: 3306, host: 3306
  config.vm.network "forwarded_port", guest: 2220, host: 2220

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "1024"
     vb.cpus = 1
   end

  # Salt Provisioner
  config.vm.provision :salt do |salt|
    salt.colorize = true
    salt.masterless = true
    salt.minion_config = "saltstack/etc/minion"
    salt.run_highstate = true
    salt.install_type = "stable"
    salt.verbose = true
  end

end

