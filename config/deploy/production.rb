Capistrano::Configuration.instance(:must_exist).load do

  puts ' PRODUCTION '.center(70, '-')

  set :user,   "deploy" 
  set :proxy,  "bamru1" 

  server proxy, :app, :web, :db, :primary => true

end
