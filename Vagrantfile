# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
   vb.name = "openwhisk"
   vb.gui = false
   vb.cpus = 4
   vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
   vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
   vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
   vb.customize ['modifyvm', :id, '--memory', 4096]
 end

  config.vm.provision "file", source: "./openwhisk-native.sh", destination: "~/openwhisk-native.sh"

  config.vm.provision "shell", inline: <<-SHELL
    addgroup docker
    usermod -aG docker vagrant
  SHELL
end
