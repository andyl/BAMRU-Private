require "env_settings"

namespace :postgres do

  desc "Setup postgres user"
  task :setup_user do
    system %Q{sudo -u postgres psql -c "create user #{APP_NAME} with password '#{POSTGRES_PASS}';"}
    system %Q{sudo -u postgres psql -c "alter role #{APP_NAME} createdb;"}
  end

  desc "Show database settings"
  task :show do
    system %Q{sudo -u postgres psql -c "select * from pg_user;"}
    system %Q{sudo -u postgres psql -c "select rolname, rolcreatedb from pg_roles;"}
  end

  desc "Restore the database from sqlite"
  task :restore do
    require "env_settings"
    system  "valkyrie db/development.sqlite3 postgres://#{APP_NAME}:#{POSTGRES_PASS}@localhost:5432/#{APP_NAME}" 
  end

end

