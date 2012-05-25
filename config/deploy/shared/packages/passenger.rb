set_default(:passenger_user)   { user }
set_default(:passenger_pid)    { "#{current_path}/tmp/pids/passenger.pid" }
set_default(:passenger_config) { "#{shared_path}/config/passenger.rb" }
set_default(:passenger_log)    { "#{shared_path}/log/passenger.log" }
set_default(:passenger_workers, 2)

namespace :passenger do
  desc "Setup Passenger initializer and app configuration"
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "passenger.rb.erb", passenger_config
    template "passenger_init.erb", "/tmp/passenger_init"
    run "chmod +x /tmp/passenger_init"
    run "#{sudo} mv /tmp/passenger_init /etc/init.d/passenger_#{application}"
    run "#{sudo} update-rc.d -f passenger_#{application} defaults"
  end
  after "deploy:setup", "passenger:setup"

  %w[start stop restart].each do |command|
    desc "#{command} passenger"
    task command, roles: :app do
      run "service passenger_#{application} #{command}"
    end
    after "deploy:#{command}", "passenger:#{command}"
  end
end
