require 'yaml'
namespace :ntp do
  set :ntp_default_ntpd_opts, "NTPD_OPTS='-g'"
  set :ntp_server_pool, "nl.pool.ntp.org"

  desc "Install NTP"
  task :install, :roles => :app do
    sudo "aptitude install -y ntp"
    configure
  end

  desc "Configure NTP"
  task :configure, :roles => :app do
    put render("ntpdate", binding), "ntpdate"
    sudo "mv ntpdate /etc/default/ntpdate"
    put render("ntp.conf", binding), "ntp.conf"
    sudo "mv ntp.conf /etc/ntp.conf"
    run "echo '#{ntp_default_ntpd_opts}' > ntp"
    sudo "mv ntp /etc/default/ntp"
    restart
  end

  desc "Start the NTP server"
  task :start, :roles => :app do
    sudo "/etc/init.d/ntp start"
  end

  desc "Restart the NTP server"
  task :restart, :roles => :app do
    sudo "/etc/init.d/ntp restart"
  end

  desc "Stop the NTP server"
  task :stop, :roles => :app do
    sudo "/etc/init.d/ntp stop"
  end
end