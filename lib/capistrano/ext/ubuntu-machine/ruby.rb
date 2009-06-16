require 'net/http'

namespace :ruby do
  desc "Install Ruby 1.8"
  task :install, :roles => :app do
    sudo "apt-get install -y ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 libruby1.8 libopenssl-ruby sqlite3 libsqlite3-ruby1.8"
    sudo "apt-get install -y libmysql-ruby1.8"

    sudo "ln -s /usr/bin/ruby1.8 /usr/bin/ruby"
    sudo "ln -s /usr/bin/ri1.8 /usr/bin/ri"
    sudo "ln -s /usr/bin/rdoc1.8 /usr/bin/rdoc"
    sudo "ln -s /usr/bin/irb1.8 /usr/bin/irb"
  end
  

  set :ruby_enterprise_url do
    path = Net::HTTP.get('www.rubyenterpriseedition.com', '/download.html').scan(/<a href="\/ruby-enterprise-.*\.tar\.gz/).first
    path.gsub!('<a href="','http://www.rubyenterpriseedition.com')
    path
  end

  set :ruby_enterprise_version do
    "#{ruby_enterprise_url[/(ruby-enterprise.*)(.tar.gz)/, 1]}"
  end

  set :ruby_enterprise_path_prefix do
    '/opt'
  end
  
  set :passenger_version do
    `gem list passenger$ -r`.gsub(/[\n|\s|passenger|(|)]/,"")
  end
  

  desc "Install Ruby Enterpise Edition"
  task :install_enterprise, :roles => :app do
    sudo "apt-get install libssl-dev -y"
    sudo "apt-get install libreadline5-dev -y"
    
    run "test ! -d #{ruby_enterprise_path_prefix}/#{ruby_enterprise_version}"
    run "wget #{ruby_enterprise_url}"
    run "tar xzvf #{ruby_enterprise_version}.tar.gz"
    run "rm #{ruby_enterprise_version}.tar.gz"
    sudo "./#{ruby_enterprise_version}/installer --auto #{ruby_enterprise_path_prefix}/#{ruby_enterprise_version}"
    sudo "rm -rf #{ruby_enterprise_version}/"
    
    # create a "permanent" link to the current REE install
    sudo "ln -s #{ruby_enterprise_path_prefix}/#{ruby_enterprise_version} #{ruby_enterprise_path_prefix}/ruby-enterprise" 
    
    # add REE bin to the path
    run "cat /etc/environment > ~/environment.tmp"
    run 'echo PATH="%s/ruby-enterprise/bin:$PATH" >> ~/environment.tmp' % ruby_enterprise_path_prefix
    sudo 'mv ~/environment.tmp /etc/environment'
  end
  
  desc "Install Phusion Passenger"
  task :install_passenger, :roles => :app do
    # rake 0.8.5 needs latest version of rdoc
    sudo "gem install rdoc"
    
    # because  passenger-install-apache2-module do not find the rake installed by REE
    sudo "gem install rake"

    sudo "apt-get install apache2-mpm-prefork -y"
    sudo "apt-get install libapr1-dev -y"
    sudo "apt-get install apache2-prefork-dev -y"

    # call the upgrade_passenger task
    upgrade_passenger
  end 
  
  desc "Upgrade Phusion Passenger"
  task :upgrade_passenger, :roles => :app do
    sudo "#{ruby_enterprise_path_prefix}/#{ruby_enterprise_version}/bin/ruby #{ruby_enterprise_path_prefix}/#{ruby_enterprise_version}/bin/gem install passenger"
    run "sudo #{ruby_enterprise_path_prefix}/#{ruby_enterprise_version}/bin/ruby #{ruby_enterprise_path_prefix}/#{ruby_enterprise_version}/bin/passenger-install-apache2-module --auto"

    put render("passenger.load", binding), "/home/#{user}/passenger.load"
    put render("passenger.conf", binding), "/home/#{user}/passenger.conf"
   
    sudo "mv /home/#{user}/passenger.load /etc/apache2/mods-available/"
    sudo "mv /home/#{user}/passenger.conf /etc/apache2/mods-available/"
    
    sudo "a2enmod passenger"
    apache.force_reload
  end

  desc 'Make Ruby Enterprise and Rubygems Enterprise default'
  task :make_enterprise_default, :roles => :app do
    sudo "rm /usr/bin/ruby"
    sudo "ln -s #{ruby_enterprise_path_prefix}/ruby-enterprise/bin/ruby /usr/bin/ruby"
    sudo "rm /usr/bin/ri"
    sudo "ln -s #{ruby_enterprise_path_prefix}/ruby-enterprise/bin/ri1.8 /usr/bin/ri"
    sudo "rm /usr/bin/rdoc"
    sudo "ln -s #{ruby_enterprise_path_prefix}/ruby-enterprise/rdoc1.8 /usr/bin/rdoc"
    sudo "rm /usr/bin/irb"
    sudo "ln -s #{ruby_enterprise_path_prefix}/ruby-enterprise/irb1.8 /usr/bin/irb"
    sudo "rm /usr/bin/gem"
    sudo "ln -s #{ruby_enterprise_path_prefix}/ruby-enterprise/bin/gem /usr/bin/gem"    
  end
end
