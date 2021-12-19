# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  "burgers": {
    box_name: "ubuntu/focal64",
    forwarded_port: [
      { guest: 80, host: 28080 },
    ],
    provision_scripts: [
      { path: "./provision/0-whoami.sh" },
      { path: "./provision/1-pkg-install.sh" },
      { path: "./provision/2-clone-repo.sh" },
      { path: "./provision/3-backend.sh" },
      { path: "./provision/4-frontend.sh" }
    ],
    provision_files: [
      { source: "./provision/sausage-store-0.0.1.jar", destination: "/home/vagrant/sausage-store-0.0.1.jar" },
      { source: "./provision/sausage-store.service", destination: "/home/vagrant/sausage-store.service" }
    ],
  },
}

Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
    config.vm.define boxname do |box|
      box.vm.box = boxconfig[:box_name]
      box.vm.host_name = boxname.to_s
      #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset
      # Port-forward config if present
      if boxconfig.key?(:forwarded_port)
        boxconfig[:forwarded_port].each do |port|
          box.vm.network "forwarded_port", port
        end
      end
      # box.vm.network "public_network", ip: boxconfig[:ip_addr], bridge: "bond0"
      box.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
      end
      # provision files
      if boxconfig.key?(:provision_files)
      boxconfig[:provision_files].each do |file|
        box.vm.provision "file",
            # source file path on host
            source: file[:source],
            # destination file path on VM
            destination: file[:destination]
      end
    end
      # provision scripts
      if boxconfig.key?(:provision_scripts)
        boxconfig[:provision_scripts].each do |script|
          box.vm.provision "shell",
              # Path to script
              path: script[:path],
              # Script's args
              args: script[:args],
              # Set environment variables for script
              env: {
                PROVISIONER: "vagrant",
                VAGRANT_HOST: boxname,
              }
          ## reload VM
          # config.vagrant.plugins = ["vagrant-reload"]
          # box.vm.provision :reload if script[:reload]
        end
      end
      # config.vm.provision "shell",
      #   run: "always",
      #   inline: "ip route add default via 10.122.1.1"
    end
  end
end
