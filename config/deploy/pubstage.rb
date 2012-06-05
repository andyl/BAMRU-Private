puts ' PUBSTAGE '.center(70, '-')

set :proxy,     "bamru1"
set :branch,    fetch(:branch, "dev")
set :rails_env, fetch(:env,    "staging")

server proxy, :app, :web, :db, :primary => true

# setup vhost names in /etc/hosts
after "deploy", "ghost:remote"
after "deploy", "ghost:local"
