# vi: set ft=ruby :

BOX_NAME = :vagrant

# get bootstrap file
system "curl -s https://raw.github.com/andyl/base_util/master/bin/bootstrap_base > ~/.bootstrap_base" 

Vagrant::Config.run do |config|
  config.vm.box     = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.define BOX_NAME do |box_config|
    box_config.vm.customize ["modifyvm", :id, "--name", BOX_NAME.to_s.capitalize]
    box_config.vm.host_name = BOX_NAME.to_s.capitalize
    box_config.vm.network   :hostonly,   "192.168.33.12"
    box_config.vm.customize ["modifyvm", :id, "--memory", 750]
    box_config.vm.provision :shell do |shell|
      shell.path = "~/.bootstrap_base"
      shell.args = "vagrant --proceed"
    end
    if Dir.exist?("/home/aleak/data")
      box_config.vm.share_folder "puppet", "/puppet", "/home/aleak/data/puppet"
      box_config.vm.share_folder "apt",    "/apt",    "/home/aleak/data/apt"
    end
  end

end
