namespace :faye do

  desc "Run Faye Server"
  task :run_server do
    system "rackup faye.ru -s thin -E production 2>&1 >> log/faye.log &"
  end

  desc "Send Faye Message"
  task :send do
    faye_server = File.read("/home/aleak/.faye_server.txt").chomp
    abort("Need a message (MSG=...") unless ENV['MSG']
    system "curl #{faye_server}/faye -d ..."  # TODO: finish this!!!
  end

end