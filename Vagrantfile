Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "public_network"
  config.vm.synced_folder "./", "/dotfiles"
  config.vm.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
end
