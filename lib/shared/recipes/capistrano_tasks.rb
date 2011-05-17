set :scm, :git
set :git_shallow_clone, 1
set :deploy_to, "/home/aleak/a/#{APPDIR}"
#set :repository, "alt55.com:rr/#{APPDIR}.git"
set :repository,  "https://github.com/andyl/#{APPDIR}.git"

default_run_options[:pty] = true
set :use_sudo, false

role :web, SERVER
role :app, SERVER
role :db,  SERVER, :primary => true

desc "Deploy #{application}"
deploy.task :restart do
  run "touch #{current_path}/tmp/restart.txt"
end

desc "Update gem installation."
task :update_gems do
  system "bundle pack"
  system "cd vendor ; rsync -a --delete cache #{SERVER}:a/#{APPDIR}/shared"
  run "cd #{current_path} ; bundle install --quiet --local --path=/home/aleak/.gems"
end

desc "RUN THIS FIRST!"
task :first_deploy do
  check_for_passenger
  run "gem install rspec"
  deploy.setup
  system "/home/aleak/util/bin/vhost add #{SERVER}"
  puts "READY TO RUN on #{SERVER}"
end

after "deploy:setup", :permissions, :keysend, :deploy, :nginx_conf
after :deploy, :setup_shared_cache, :update_gems
after :nginx_conf, :restart_nginx

desc "Setup shared cache."
task :setup_shared_cache do
  cache_dir = "#{shared_path}/cache"
  vendor_dir = "#{release_path}/vendor"
  run "mkdir -p #{cache_dir} #{vendor_dir}"
  run "ln -s #{cache_dir} #{vendor_dir}/cache"
end

desc "Send SSH keys to alt55.com."
task :keysend do
#  run "keysend alt55.com"
   puts "No key setup needed - deploying from GitHub"
end

desc "Set permissions."
task :permissions do
  sudo "chown -R aleak a"
  sudo "chgrp -R aleak a"
end

desc "Create an nginx config file."
task :nginx_conf do
  run "cd #{current_path} && rake nginx_conf"
end

desc "Link the database."
task :link_db do
  db_path = "#{shared_path}/db"
  db_file = "#{release_path}/db/development.sqlite3"
  run "rm -f #{db_file}"
  run "ln -s #{db_path}/development.sqlite3 #{db_file}"
  run "touch #{release_path}/tmp/restart.txt"
end

desc "Setup the database."
task :setup_db do
  db_path = "#{shared_path}/db"
  db_file = "#{current_path}/db/development.sqlite3"
  run "rm -f #{db_file}"
  run "cd #{current_path} ; rake db:migrate --trace"
  run "cd #{current_path} ; rake db:seed --trace"
  run "mkdir -p #{db_path}"
  run "mv #{db_file} #{db_path}"
end

desc "Restart NGINX."
task :restart_nginx do
  sudo "/etc/init.d/nginx restart"
end

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

task :check_for_passenger do
  error_msg = <<-EOF

    ABORT: PLEASE INSTALL PASSENGER, THEN TRY AGAIN !!!
    sys sw install:passenger host=#{SERVER}

  EOF
  abort error_msg unless remote_file_exists?("/etc/init.d/nginx")
end

