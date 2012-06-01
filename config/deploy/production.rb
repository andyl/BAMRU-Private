Capistrano::Configuration.instance(:must_exist).load do

  puts '-' * 30, "STAGE: PRODUCTION", '-' * 30

  set :user,   "deploy" 
  set :proxy,  "bamru1" 

  server proxy, :app, :web, :db, :primary => true

end
