namespace :faye do

  desc "Run Faye Server"
  task :run_server do
    #system "rackup faye.ru -s thin -E production 2>&1 >> log/faye.log &"
    system "rackup faye.ru -s thin -E production"
  end

  desc "Send Faye Message"
  task :send do
    require 'env_settings'
    abort("Need a message (MSG='...')") unless ENV['MSG']
    msg = %Q('message={"channel":"/chats/new", "data":"#{ENV['MSG']}"}')
    cmd = "curl #{FAYE_SERVER} -d #{msg}"
    puts   cmd
    system cmd
  end

  desc "Send Faye Message"
  task :send2 do
    require 'env_settings'
    abort("Need a message (MSG='...')") unless ENV['MSG']
    message = {:channel => '/chats/new', :data => ENV['MSG']}
    uri = URI.parse(FAYE_SERVER)
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  desc "Generate Upstart config files"
  task :upstart do
    system "sudo bundle exec foreman export upstart /etc/init -u aleak -a bnet"
  end

  desc "CL Chat Client"
  task :chat do
    require 'env_settings'
    require File.dirname(File.expand_path(__FILE__)) + '/../faye_chat'
    nick    = Process.pid.to_s
    channel = "/chats/new"
    puts "Using Faye parameters #{FAYE_SERVER}, #{channel}, #{nick}"
    FayeChat.run(FAYE_SERVER, channel, nick)
  end

end
