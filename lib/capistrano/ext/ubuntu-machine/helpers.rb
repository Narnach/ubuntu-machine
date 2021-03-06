require 'erb'

# render a template
def render(file, binding)
  template = File.read("#{File.dirname(__FILE__)}/templates/#{file}.erb")
  result = ERB.new(template).result(binding)
end

# allows to sudo a command which require the user input via the prompt
def sudo_and_watch_prompt(cmd, regex_to_watch)
  sudo cmd, :pty => true do |ch, stream, data|
    watch_prompt(ch, stream, data, regex_to_watch)
  end
end

# allows to run a command which require the user input via the prompt
def run_and_watch_prompt(cmd, regex_to_watch)
  run cmd, :pty => true do |ch, stream, data|
    watch_prompt(ch, stream, data, regex_to_watch)
  end
end

# utility method called by sudo_and_watch_prompt and run_and_watch_prompt
def watch_prompt(ch, stream, data, regex_to_watch)

  # the regex can be an array or a single regex -> we force it to always be an array with [*xx]
  if [*regex_to_watch].find { |regex| data =~ regex}
    # prompt, and then send the response to the remote process
    ch.send_data(Capistrano::CLI.password_prompt(data) + "\n")
  else
    # use the default handler for all other text
    Capistrano::Configuration.default_io_proc.call(ch, stream, data)
  end
end

def add_to_file(file,lines)
  [*lines].each do |line|
    run 'echo "%s" >> %s' % [line.gsub('"','\"'),file]
  end
end

def sudo_add_to_file(file,lines)
  tmpfile = "#{File.basename(file)}.tmp"
  sudo "cp #{file} #{tmpfile}"
  # Temporarily make world read/writable so it can be appended to. 
  sudo "chmod 0777 #{tmpfile} && sudo chown #{user}:#{user} #{tmpfile}"
  add_to_file(tmpfile,lines)
  # Use cp + rm instead mv so the destination file will keep its owner/modes.
  sudo "cp #{tmpfile} #{file} && rm #{tmpfile}"
end

# Re-activate sudo session if it has expired.
def sudo_keepalive
  sudo "ls > /dev/null"
end
 
# Adds 1 or more commands to the cron tab
# - commands can be a string or an array
# - period should be a valid crontab period
# - use_sudo can be set to true if you want to edit the root crontab.
def add_to_crontab(commands,period,use_sudo=false)
  send_cmd = use_sudo ? :sudo : :run
  tmp_cron="/tmp/cron.tmp"
  self.send(send_cmd, "rm -f #{tmp_cron} && touch #{tmp_cron}")
  run "(#{use_sudo ? 'sudo ' : ''}crontab -l || true) > #{tmp_cron}"
  cron_lines = [*commands].map{|cmd| "#{period} #{cmd}"}
  add_to_file(tmp_cron, cron_lines)
  self.send(send_cmd, "crontab #{tmp_cron}")
  sudo "rm -f #{tmp_cron}"
end

# Adds 1 or more commands to the cron tab of root
# - commands can be a string or an array
# - period should be a valid crontab period
def sudo_add_to_crontab(commands,period)
  add_to_crontab(commands, period, true)
end