Capistrano::Configuration.instance(:must_exist).load do

  before "deploy:setup", "postgresql:create_database_user"

  namespace :postgresql do

    desc "Create a database user for this application."
    task :create_database_user, roles: :db, only: {primary: true} do
      run %Q{#{sudo} -u postgres psql -c "create user #{app_name} with password '#{POSTGRES_PASS}' login createdb;"}
    end

  end

end
