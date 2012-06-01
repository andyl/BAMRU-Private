Capistrano::Configuration.instance(:must_exist).load do

  # namespace for Operations Tasks
  namespace :ops do

    desc "Setup and run initial deploy"
    task :setup do
      deploy.setup
      deploy.cold
    end

    desc "Run the App Console"
    task :console do
      system "ssh -t #{user}@#{proxy} tmux_console #{current_path}/script/tmpro"
    end

  end

end
