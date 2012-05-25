server proxy, :app, :web, :db, :primary => true

# setup vhost names in /etc/hosts
after "deploy", "ghost:remote"
after "deploy", "ghost:local"

