require 'rubygems'
require 'bundler/setup'
require File.expand_path('./lib/env_settings', File.dirname(__FILE__))

# ===== App Config =====
set :app_name,    APP_NAME         # <- this comes from lib/env_settings
set :application, "BAMRU-Private"
set :repository,  "https://github.com/andyl/#{application}.git"
set :vhost_names, %w(bnet bnettest)
set :web_port,    8500

# ===== Stage-Specific Code =====
stage = "staging"            # <--- set to one of [vagrant|staging|production]
require File.expand_path("config/deploy/#{stage}", File.dirname(__FILE__))

# ===== Common Code for All Stages =====
load 'deploy'
base_dir = File.expand_path(File.dirname(__FILE__))
Dir.glob("config/deploy/shared/base/*.rb").each {|f| require base_dir + '/' + f}
Dir.glob("config/deploy/shared/recipes/*.rb").each {|f| require base_dir + '/' + f}

# ===== Package Definitions =====
require base_dir + "/config/deploy/shared/packages/nginx"
require base_dir + "/config/deploy/shared/packages/foreman"
require base_dir + "/config/deploy/shared/packages/sqlite"
require base_dir + "/config/deploy/shared/packages/postgresql"

# ===== App-Specific Tasks =====

before 'deploy:setup',  'keys:upload'

namespace :keys do

  desc "upload keys"
  task :upload do
    file = ".bnet_environment.yaml"
    keyfile = File.expand_path("~/#{file}")
    keytext = File.read(keyfile)
    tgtfile = "/home/#{user}/#{file}"
    put keytext, tgtfile 
    run "chown -R #{user} #{tgtfile}"
    run "chgrp -R #{user} #{tgtfile}"
  end

end

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

