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
end