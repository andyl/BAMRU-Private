puts ' Target Environment: PRODUCTION '.center(70, '-')

set :user,      "deploy"
# set :proxy,     "bamru1"
set :proxy,     "bamru.info"
set :branch,    fetch(:branch, "master")
set :rails_env, fetch(:env,    "production")

server proxy, :app, :web, :db, :primary => true
