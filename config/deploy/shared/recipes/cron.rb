
Capistrano::Configuration.instance(:must_exist).load do

  after 'deploy', 'cron:reset'

  namespace :cron do

    desc "Reset Cron"
    task :reset do
      set(:whenever_environment) { stage }
      require 'whenever/capistrano'
      run "cd #{current_path} && whenever --update-crontab #{application}"
    end

  end

end
