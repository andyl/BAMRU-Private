namespace :postgres do

  desc "Setup postgres user"
  task :setup_user do
    require "env_settings"
    system %Q{sudo -u postgres psql -c "create user #{APP_NAME} with password '#{POSTGRES_PASS}';"}
  end

end
