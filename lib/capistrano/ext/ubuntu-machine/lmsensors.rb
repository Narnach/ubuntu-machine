require 'yaml'
namespace :lmsensors do
  desc "Install lmsensors"
  task :install do
    sudo "aptitude install -y lm-sensors"
    to_probe = []
    sudo "sensors-detect", :pty => true do |ch, stream, data|
      if [/YES\/no/,/yes\/NO/,/to continue/].find { |regex| data =~ regex}
        # prompt, and then send the response to the remote process
        ch.send_data(Capistrano::CLI.password_prompt(data) + "\n")
      elsif offset = data =~ /#----cut here----\s+# Chip drivers/
        text = data[offset,data.size - offset]
        text.gsub!('# Chip drivers','').gsub!('#----cut here----','')
        to_probe = text.strip.split("\n").map{|str| str.strip}
        Capistrano::Configuration.default_io_proc.call(ch, stream, data)
      else
        # use the default handler for all other text
        Capistrano::Configuration.default_io_proc.call(ch, stream, data)
      end
    end
    puts "Will prob the following modules:" % to_probe.join(',')
    to_probe.each do |mod|
      sudo "modprobe #{mod}"
    end
  end
end