Capistrano::Configuration.instance(:must_exist).load do

  # namespace for App Tasks
  namespace :at do

    desc "Setup and run initial deploy"
    task :setup do
      deploy.setup
      deploy.cold
    end

    desc "Deploy the application"
    task :dep do
      deploy
    end

    desc "Roll back the application"
    task :rback do
      deploy.rollback
    end

    desc "Run the App Console"
    task :console do
      system "ssh -t #{user}@#{proxy} tmux_console #{current_path}/script/tmpro"
    end

  end

end
