require 'env_settings'

require File.dirname(__FILE__) + "/../../lib/notifications_util"

namespace :faye do

  desc "Broadcast the Date"
  task :datecast do
    time = Time.now.strftime("%a %b %d")
    data = prep_data(["date", Time.now, "-", "-", {:text => time}])
    write_log(data)
  end

  desc "Run Faye Server"
  task :run_server do
    system "rackup faye.ru -s thin -E production"
  end

  desc "Send Faye Message using CURL"
  task :send_curl do
    abort("Need a message (MSG='...')") unless ENV['MSG']
    msg = %Q('message={"channel":"/chats/new", "data":"#{ENV['MSG']}"}')
    cmd = "curl #{FAYE_SERVER} -d #{msg}"
    puts   cmd
    system cmd
  end

  desc "Send Faye Message using HTTP Post"
  task :send_post do
    abort("Need a message (MSG='...')") unless ENV['MSG']
    message = {:channel => '/chats/new', :data => ENV['MSG']}
    uri = URI.parse(FAYE_SERVER)
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  desc "Generate Upstart config files"
  task :upstart do
    system "sudo bundle exec foreman export upstart /etc/init -u aleak -a bnet"
  end

  desc "CL Chat Client CHANNEL='/chats/new'"
  task :chat do
    require File.dirname(File.expand_path(__FILE__)) + '/../faye_chat'
    nick    = Process.pid.to_s
    channel = ENV['CHANNEL'] || "/chats/new"
    puts "Using Faye parameters #{FAYE_SERVER}, #{channel}, #{nick}"
    FayeChat.run(FAYE_SERVER, channel, nick)
  end

end
