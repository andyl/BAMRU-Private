Capistrano::Configuration.instance(:must_exist).load do

  after 'deploy', 'cron:reset'

  namespace :cron do

    desc "Reset Cron"
    task :reset do
      run "cd #{release_path} && bundle exec whenever --update-crontab #{application}"
    end

  end

end
