Capistrano::Configuration.instance(:must_exist).load do

  puts ' VAGRANT '.center(70, '-')

  set :user,   "vagrant" 
  set :proxy,  "vagrant" 

  server proxy, :app, :web, :db, :primary => true

  # setup vhost names in /etc/hosts
  after "deploy", "ghost:remote"
  after "deploy", "ghost:local"

end
