namespace :network do
  desc "Configure /etc/resolv.conf and /etc/network/interfaces"
  task :configure, :roles => :gateway do
    configure_resolv_conf
    configure_network_interfaces
  end

  desc "Configure network interfaces"
  task :configure_network_interfaces, :roles => :gateway do
    put File.read(network_interfaces_config), "interfaces"
    sudo "mv interfaces /etc/network/interfaces"
    sudo "/etc/init.d/networking restart"
  end

  desc "Configure /etc/resolv.conf"
  task :configure_resolv_conf, :roles => :gateway do
    put File.read(resolv_config), "resolv.conf"
    sudo "mv resolv.conf /etc/resolv.conf"
  end
end
