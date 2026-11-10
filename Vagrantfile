# -*- mode: ruby -*-
# Создаёт два узла OpenVPN и пробрасывает UDP для RAS.
ras_bind = ENV.fetch("VPN_RAS_BIND", "127.0.0.1")
ras_remote = ENV.fetch("VPN_RAS_REMOTE", ras_bind)
abort "Укажите VPN_RAS_REMOTE для адреса 0.0.0.0" if ras_remote == "0.0.0.0"
abort "Некорректный адрес VPN_RAS_REMOTE" unless ras_remote.match?(/\A[A-Za-z0-9.-]+\z/)

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"
  config.vm.box_version = "4.3.12"
  config.vm.box_check_update = false
  config.vm.boot_timeout = 900
  config.vm.synced_folder ".", "/vagrant", disabled: true

  {"vpnServer" => "172.26.77.10", "vpnClient" => "172.26.77.11"}.each do |name, address|
    server = name == "vpnServer"
    config.vm.define name do |vm|
      vm.vm.hostname = name.downcase
      vm.vm.provider "virtualbox" do |vb|
        vb.name = "otus-vpn-lab-#{name}"
        vb.cpus = 1
        vb.memory = 1024
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end
      vm.vm.network "private_network", ip: address, netmask: "255.255.255.0",
                    virtualbox__intnet: "otus-vpn-lab-underlay"
      if server
        vm.vm.network "forwarded_port", guest: 1194, host: 11940, protocol: "udp",
                      host_ip: ras_bind, auto_correct: false, id: "ras-udp"
      end
      vm.vm.provision "ansible" do |ansible|
        ansible.playbook = "ansible/provision.yml"
        ansible.extra_vars = {
          vpn_server: server,
          vpn_underlay_local: address,
          vpn_underlay_peer: server ? "172.26.77.11" : "172.26.77.10",
          vpn_ras_remote: ras_remote
        }
      end
    end
  end
end

# Версия 1 | 2026-11-09 | Две ВМ, внутренняя сеть и UDP-проброс RAS.
