Gem::Specification.new do |s|
  s.name     = "ubuntu-machine"
  s.version  = "0.5.3.2.3"
  s.date     = "2009-06-12"
  s.summary  = "Capistrano recipes for setting up and deploying to a Ubuntu Machine"
  s.email    = "thomas@suitmymind.com"
  s.homepage = "http://suitmymind.github.com/ubuntu-machine"
  s.description = "Capistrano recipes for setting up and deploying to a Ubuntu Machine"
  s.has_rdoc = false
  s.authors  = ["Thomas Balthazar","Tarik Alkasab","Filip H.F. 'FiXato' Slagter"]
  # s.files    = Dir["README", "MIT-LICENSE", "lib/capistrano/ext/**/*"]
  s.files    = ["README", 
                "MIT-LICENSE", 
                "lib/capistrano/ext/ubuntu-machine.rb", 
                "lib/capistrano/ext/ubuntu-machine/apache.rb", 
                "lib/capistrano/ext/ubuntu-machine/aptitude.rb", 
                "lib/capistrano/ext/ubuntu-machine/gems.rb", 
                "lib/capistrano/ext/ubuntu-machine/git.rb", 
                "lib/capistrano/ext/ubuntu-machine/odbc.rb", 
                "lib/capistrano/ext/ubuntu-machine/helpers.rb", 
                "lib/capistrano/ext/ubuntu-machine/iptables.rb", 
                "lib/capistrano/ext/ubuntu-machine/machine.rb", 
                "lib/capistrano/ext/ubuntu-machine/mysql.rb", 
                "lib/capistrano/ext/ubuntu-machine/php.rb", 
                "lib/capistrano/ext/ubuntu-machine/postfix.rb", 
                "lib/capistrano/ext/ubuntu-machine/ruby.rb", 
                "lib/capistrano/ext/ubuntu-machine/ssh.rb", 
                "lib/capistrano/ext/ubuntu-machine/tmpfs.rb", 
                "lib/capistrano/ext/ubuntu-machine/utils.rb", 
                "lib/capistrano/ext/ubuntu-machine/vsftpd.rb", 
                "lib/capistrano/ext/ubuntu-machine/templates/apache2.erb", 
                "lib/capistrano/ext/ubuntu-machine/templates/iptables.erb", 
                "lib/capistrano/ext/ubuntu-machine/templates/my.cnf.erb", 
                "lib/capistrano/ext/ubuntu-machine/templates/new_db.erb", 
                "lib/capistrano/ext/ubuntu-machine/templates/passenger.conf.erb", 
                "lib/capistrano/ext/ubuntu-machine/templates/passenger.load.erb", 
                "lib/capistrano/ext/ubuntu-machine/templates/sshd_config.erb", 
                "lib/capistrano/ext/ubuntu-machine/templates/vhost.erb", 
                "lib/capistrano/ext/ubuntu-machine/templates/vsftpd.conf.erb",
                "lib/capistrano/ext/ubuntu-machine/templates/deflate.conf.erb",
                "lib/capistrano/ext/ubuntu-machine/templates/freetds.conf.erb",
                "lib/capistrano/ext/ubuntu-machine/templates/odbc.ini.erb",
                "lib/capistrano/ext/ubuntu-machine/templates/odbcinst.ini.erb"]
  
  s.add_dependency("capistrano", ["> 2.5.2"])
end
