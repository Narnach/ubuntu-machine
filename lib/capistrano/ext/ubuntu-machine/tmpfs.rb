namespace :tmpfs do
  set :tmpfs_directories do
    {
      '/tmpfs' => {:size => '2G', :mode => '0744'},
    }
  end

  desc "Create tmpfs directories"
  task :create_directories, :roles => :app do
    tmpfs_directories.each do |dir,options|
      options[:size] = '2G' if options[:size].nil?
      options[:mode] = '0744' if options[:mode].nil?
      sudo "mkdir -p #{dir}"
      sudo "mount -t tmpfs -o size=#{options[:size]},mode=#{options[:mode]} tmpfs #{dir}"
      run "cp /etc/fstab fstab.tmp"
      run "echo 'tmpfs #{dir} tmpfs size=#{options[:size]},mode=#{options[:mode]} 0 0' >> fstab.tmp"
      sudo "mv fstab.tmp /etc/fstab"
    end
  end

  desc "Create ftp directories within :vsftpd_tmpfs_directory for each user defined in :vsftpd_users and symlink in their homedirs"
  task :create_vsftpd_tmpfs_dirs, :roles => :app do
    vsftpd_users.each do |target_user|
      sudo "mkdir -p #{File.join(vsftpd_tmpfs_directory,target_user)}"
      sudo "ln -s #{File.join(vsftpd_tmpfs_directory,target_user)} ~#{target_user}/ftp"
      sudo "chown #{target_user}:#{vsftpd_group} ~#{target_user}/ftp"
    end
  end
end