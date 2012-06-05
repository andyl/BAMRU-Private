puts ' PRODUCTION '.center(70, '-')

set :proxy,     "bamru1"
set :branch,    fetch(:branch, "master")
set :rails_env, fetch(:env,    "production")

server proxy, :app, :web, :db, :primary => true
