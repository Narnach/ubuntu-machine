namespace :gems do
  desc "Install RubyGems"
  task :install_rubygems, :roles => :app do
    run "wget http://rubyforge.org/frs/download.php/45905/rubygems-#{rubygem_version}.tgz"
    run "tar xvzf rubygems-#{rubygem_version}.tgz"
    run "cd rubygems-#{rubygem_version} && sudo ruby setup.rb"
    sudo "ln -s /usr/bin/gem1.8 /usr/bin/gem"
    sudo "gem update"
    sudo "gem update --system"
    run "rm -Rf rubygems-#{rubygem_version}*"
  end
  
  desc "List gems on remote server"
  task :list, :roles => :app do
    stream "gem list"
  end

  desc "Update gems on remote server"
  task :update, :roles => :app do
    sudo "gem update"
  end
  
  desc "Update gem system on remote server"
  task :update_system, :roles => :app do
    sudo "gem update --system"
  end

  desc "Install a gem on the remote server"
  task :install, :roles => :app do
    name = Capistrano::CLI.ui.ask("Which gem should we install: ")
    sudo "gem install #{name}"
  end

  desc "Uninstall a gem on the remote server"
  task :uninstall, :roles => :app do
    name = Capistrano::CLI.ui.ask("Which gem should we uninstall: ")
    sudo "gem uninstall #{name}"
  end

  desc "Scp local gem to the remote server and install it"
  task :deploy_local_gem, :roles => :app do
    local_gem_path = Capistrano::CLI.ui.ask("Please supply the path to the local gem: ")
    run "mkdir -p gems"
    `scp -P #{ssh_options[:port]} #{File.expand_path(local_gem_path)} #{user}@#{server_name}:gems/`
    sudo "gem install -l gems/#{File.basename(local_gem_path)}"
  end

  desc "Scp a set of local gems preconfigured in :local_gems_to_deploy to the remote server and install them"
  task :deploy_local_gems, :roles => :app do
    run "mkdir -p gems"
    local_gems_to_deploy.each do |local_gem_path|
      `scp -P #{ssh_options[:port]} #{File.expand_path(local_gem_path)} #{user}@#{server_name}:gems/`
      sudo "gem install -l gems/#{File.basename(local_gem_path)}"
    end
  end
end
