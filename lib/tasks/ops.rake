require 'rake_util'

include RakeUtil

# ----- Rake Tasks -----

namespace :ops do

  desc "Set DO"
  task :set_do => 'environment' do
    cmd = curl_get("api/do/set_do")
    puts "Setting DO Assignment"
    puts cmd.gsub(SYSTEM_PASS, "....")
    system cmd
    STDOUT.flush
  end

  desc "RAKE TEST COMMAND"
  task :raketest do
    puts "STARTING TEST COMMAND (PID: #{Process.pid})"
    STDOUT.flush
    sleep 10
    puts "ENDING TEST COMMAND (PID: #{Process.pid})"
    STDOUT.flush
  end

  desc "Cleanup Log Files"
  task :log_cleanup => 'environment' do
    logdir         = Rails.root.to_s + "/log"
    nq_log         = logdir + "/nq.log"
    production_log = logdir + "/production.log"
    date           = Time.now.to_s
    system "echo 'Log File Reset (#{date})' > #{nq_log}"
    system "echo 'Log File Reset (#{date})' > #{production_log}"
    puts "Log Files Reset"
  end
  
end
