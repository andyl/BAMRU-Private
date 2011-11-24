require 'rake_util'

include RakeUtil

# ----- Rake Tasks -----

namespace :ops do

  desc "Set DO"
  task :set_do => 'environment' do
    cmd = curl_get("api/rake/ops/set_do")
    puts "Setting DO Assignment"
    system cmd
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

  desc "Cleanup Message Files"
  task :message_cleanup => 'environment' do
    cmd = curl_get("api/rake/ops/message_cleanup")
    puts "Cleaning up old messages"
    system cmd
    STDOUT.flush
  end
  
end
