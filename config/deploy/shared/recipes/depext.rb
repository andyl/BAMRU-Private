Capistrano::Configuration.instance(:must_exist).load do

  namespace :cron do

    desc "Reset Cron"
    task :reset do
      run "cd #{release_path} && bundle exec whenever --update-crontab #{application}"
    end

  end

end
