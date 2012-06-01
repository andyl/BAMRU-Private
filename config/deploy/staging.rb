Capistrano::Configuration.instance(:must_exist).load do

  puts ' STAGING '.center(70, '-')

  set :user,   "deploy" 
  set :proxy,  "staging" 

  server proxy, :app, :web, :db, :primary => true

  # setup vhost names in /etc/hosts
  after "deploy", "ghost:remote"
  after "deploy", "ghost:local"

end

