Capistrano::Configuration.instance(:must_exist).load do

  after 'deploy:update', 'foreman:export'
  after 'deploy:update', 'foreman:restart'
  after 'deploy:rollback:revision', 'foreman:export_rollback'
  #after 'deploy:rollback', 'foreman:restart'

  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export, :roles => :app do
      run "#{sudo} rm -f /etc/init/#{app_name}*.conf"
      run "cd #{release_path} && foreman export upstart /tmp/xinit -e .rbenv-vars -p #{web_port} -a #{app_name} -u #{user} -l #{shared_path}/log"
      run "#{sudo} mv /tmp/xinit/* /etc/init"
      run "rm -rf /tmp/xinit"
    end
    task :export_rollback, :roles => :app do
      run "#{sudo} rm -f /etc/init/#{app_name}*.conf"
      run "cd #{current_path} && foreman export upstart /tmp/xinit -e .rbenv-vars -p #{web_port} -a #{app_name} -u #{user} -l #{shared_path}/log"
      run "#{sudo} mv /tmp/xinit/* /etc/init"
      run "rm -rf /tmp/xinit"
    end
    desc "Start the application services"
    task :start, :roles => :app do
      run "#{sudo} start #{app_name}"
    end

    desc "Stop the application services"
    task :stop, :roles => :app do
      run "#{sudo} stop #{app_name}"
    end

    desc "Restart the application services"
    task :restart, :roles => :app do
      run "#{sudo} start #{app_name} || #{sudo} restart #{app_name}"
    end
  end

end
