Capistrano::Configuration.instance(:must_exist).load do

  namespace :deploy do

    desc "Start #{application}"
    task :start do
      run "echo Starting application"
    end

    desc "Stop #{application}"
    task :start do
      run "echo Stopping application"
    end

    desc "Restart #{application}"
    task :restart do
      run "echo Restarting application"
      run "mkdir -p #{current_path}/tmp"
      run "touch #{current_path}/tmp/restart.txt"
    end

  end

end
