# vi: set ft=ruby :

BOX_NAME = :bnetv

Vagrant::Config.run do |config|
  config.vm.box     = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.define BOX_NAME do |box_config|
    box_config.vm.customize ["modifyvm", :id, "--name", BOX_NAME.to_s.capitalize]
    box_config.vm.host_name = BOX_NAME.to_s.capitalize
    box_config.vm.network      :hostonly,   "192.168.33.12"
    box_config.vm.forward_port 3000, 3001
    box_config.vm.forward_port 8989, 8989
    box_config.vm.customize ["modifyvm", :id, "--memory", 750]
    box_config.vm.provision :shell do |shell|
      shell.path = "~/util/base_util/bin/bootstrap_base"
      shell.args = "vagrant --proceed"
    end
    box_config.vm.share_folder "puppet", "/puppet", "/home/aleak/data/puppet"
    box_config.vm.share_folder "apt",    "/apt",    "/home/aleak/data/apt"
  end

end
