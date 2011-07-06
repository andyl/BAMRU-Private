namespace :faye do

  desc "Run Faye Server"
  task :run_server do
    system "rackup faye.ru -s thin -E production 2>&1 >> log/faye.log &"
  end

  desc "Send Faye Message"
  task :send do
    server = File.read("/home/aleak/.faye_server.txt").chomp
    abort("Need a message (MSG='...')") unless ENV['MSG']
    msg = %Q('message={"channel":"/chats/new", "data":"#{ENV['MSG']}"}')
    cmd = "curl #{server} -d #{msg}"
    puts   cmd
    system cmd
  end

  desc "CL Chat Client"
  task :chat do
    require File.dirname(File.expand_path(__FILE__)) + '/../faye_chat'
    nick    = Process.pid.to_s
    server  = File.read("/home/aleak/.faye_server.txt").chomp
    channel = "/chats/new"
    puts "Using Faye parameters #{server}, #{channel}, #{nick}"
    FayeChat.run(server, channel, nick)
  end

end
