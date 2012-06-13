Capistrano::Configuration.instance(:must_exist).load do

  desc "Run the App Dashboard"
  task :console do
    system "ssh -t #{user}@#{proxy} tmux_console #{current_path}/script/tmpro"
  end

  task :con do
    console
  end

end
