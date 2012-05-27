
namespace :postgresql do

  desc "Create a database user for this application."
  task :create_database_user, roles: :db, only: {primary: true} do
    run %Q{#{sudo} -u postgres psql -c "create user #{application} with password '#{POSTGRES_PASS}';"}
  end
  after "deploy:setup", "postgresql:create_database_user"
end
