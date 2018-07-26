Vagrant.configure("2") do |config|

    ENV['VAULT_IP']||="192.168.5.11"
    ENV['VAULT_NAME']||="leader01"

    #global config
    config.vm.synced_folder ".", "/vagrant"
    config.vm.synced_folder ".", "/usr/local/bootstrap"
    config.vm.box = "allthingscloud/go-counter-demo"
    config.vm.provision "shell", path: "scripts/install_consul.sh", run: "always"

    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 1
    end

    config.vm.define "vault01" do |vault01|
        vault01.vm.hostname = ENV['VAULT_NAME']
        vault01.vm.provision "shell", path: "scripts/install_vault.sh", run: "always"
        vault01.vm.provision "shell", path: "scripts/configure_app_role.sh", run: "always"
        vault01.vm.provision "shell", path: "scripts/install_demo_app.sh", run: "always"
        vault01.vm.network "private_network", ip: ENV['VAULT_IP']
        vault01.vm.network "forwarded_port", guest: 8500, host: 8500
        vault01.vm.network "forwarded_port", guest: 8200, host: 8200
    end
end
