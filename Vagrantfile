BOX_IMAGE = "bento/ubuntu-20.04"

Vagrant.configure("2") do |config|
  # config.vm.box = "ubuntu/focal64"
  config.vm.network "public_network"
  # config.vm.synced_folder "./", "/dotfiles"

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "bento/ubuntu-20.04"
    ubuntu.vm.hostname = "ubuntu"
    ubuntu.vm.synced_folder "./", "/dotfiles"
    ubuntu.vm.provision "file", source: "~/.ssh/id_rsa", destination: "~/.ssh/id_rsa"
    ubuntu.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"
  end

  config.vm.define "ubuntu2" do |ubuntu|
    ubuntu.vm.box = "bento/ubuntu-20.04"
    ubuntu.vm.hostname = "ubuntu2"
    ubuntu.vm.synced_folder "./", "/dotfiles"
    ubuntu.vm.provision "file", source: "~/.ssh/id_rsa", destination: "~/.ssh/id_rsa"
    ubuntu.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"
  end
end
