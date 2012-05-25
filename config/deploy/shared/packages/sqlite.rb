Capistrano::Configuration.instance(:must_exist).load do

  after 'deploy:setup',  'sqlite:make_shared_db'
  after 'deploy:update', 'sqlite:link_shared_db'

  namespace :sqlite do

    desc "Make a shared database folder"
    task :make_shared_db, :roles => :db do
      run "mkdir -p #{shared_path}/db"
      upload "db/development.sqlite3", "#{shared_path}/db/production.sqlite3"
    end

    desc "Link shared database"
    task :link_shared_db, :roles => :db do
      run "rm -f #{release_path}/db/production.sqlite3"
      run "ln -s #{shared_path}/db/production.sqlite3 #{release_path}/db/production.sqlite3"
    end

  end

end
