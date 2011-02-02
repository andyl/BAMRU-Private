SERVER       = "alt55.com"

set :application, "BAMRU TEST APP"
set :repository,  "https://github.com/andyl/BAMRU-Public.git"
set :deploy_to,   "/home/aleak/a/btest"

load 'deploy' if respond_to?(:namespace)
Dir['/vendor/plugins/*/recipes/*.rb'].each { |p| load p }

set :use_sudo, false

set :scm, :git

role :web, SERVER
role :app, SERVER
role :db,  SERVER, :primary => true

desc "Deploy #{application}"
deploy.task :restart do
  run "touch #{current_path}/tmp/restart.txt"
end

