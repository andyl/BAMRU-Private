
Capistrano::Configuration.instance(:must_exist).load do

  after 'deploy', 'cron:reset'

  namespace :cron do

    desc "Reset Cron"
    task :reset do
      run "cd #{current_path} && whenever --update-crontab #{application} -s 'environment=#{stage}'"
    end

  end

end
