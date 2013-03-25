require 'rubygems'
require 'bundler/setup'
load    'deploy/assets'
require File.expand_path('./lib/env_settings', File.dirname(__FILE__))

# ===== App Config =====
set :app_name,    APP_NAME         # <- this comes from lib/env_settings
set :application, "BAMRU-Private"
set :repository,  "https://github.com/andyl/#{application}.git"
set :vhost_names, %w(bamru.net bnet www.bamru.net bamru1)
set :web_port,    8500

# ===== Stage-Specific Code =====
set :stages, %w(vagrant devstage pubstage production)
# set :default_stage, "vagrant"
set :default_stage, "production"
require 'capistrano/ext/multistage'

# ===== Common Code for All Stages =====
load 'deploy'
share_dir = File.expand_path("config/deploy/shared", File.dirname(__FILE__))
require "#{share_dir}/tasks"

# ===== Package Definitions =====
require share_dir + "/packages/cron"        # setup cron using whenever
require share_dir + "/packages/passenger"   # nginx config
require share_dir + "/packages/foreman"     # foreman processes managed by upstart
require share_dir + "/packages/postgresql"  # postgres database
require share_dir + "/packages/monit"       # setup monit_alert
require share_dir + "/packages/faye"        # update faye server environment variablejj

# ===== App-Specific Tasks =====

# ----- sysdir -----
after 'deploy:setup',  'sysdir:setup'
after 'deploy',        'sysdir:symlink'

namespace :sysdir do

  desc "Create shared system directory"
  task :setup do
    run "mkdir -p #{shared_path}/system"
    run "chown -R #{user} #{shared_path}/system"
    run "chgrp -R #{user} #{shared_path}/system"
  end

  desc "Symlink to the shared system directory"
  task :symlink do
    run "rm -rf #{release_path}/public/system"
    run "ln -s #{shared_path}/system #{release_path}/public/system"
  end

end

namespace :deploy do
  namespace :assets do
    desc "Precompile assets on local machine then upload them to the server."
    task :precompile, roles: :web, except: {no_release: true} do
      run_locally "rake assets:precompile:primary RAILS_ENV=production"
      find_servers_for_task(current_task).each do |server|
        run_locally "rsync -vr public/assets #{user}@#{server.host}:#{shared_path}/"
      end
      run "cd #{current_release} ; cp public/assets/manifest.yml ./assets_manifest.yml"
    end
  end
end



