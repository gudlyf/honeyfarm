# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "honeyfarmer"

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "private_network", ip: "192.168.33.10"

  # config.vm.network "public_network"
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "1024"
   end

  # Salt Provisioner
  config.vm.provision :salt do |salt|
    salt.minion_config = "saltstack/etc/minion"
    salt.run_highstate = true
    salt.install_type = "git"
    salt.install_args = "v2016.11.4"
    salt.verbose = true
  end

end
