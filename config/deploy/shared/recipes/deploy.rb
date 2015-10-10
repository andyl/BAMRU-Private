Capistrano::Configuration.instance(:must_exist).load do

  namespace :deploy do

    desc "Start #{application}"
    task :start do
      run "echo Starting application"
    end

    desc "Stop #{application}"
    task :stop do
      run "echo Stopping application"
    end

    desc "Restart #{application}"
    task :restart do
      run "echo Restarting application"
      run "mkdir -p #{current_path}/tmp"
      run "touch #{current_path}/tmp/restart.txt"
    end

    namespace :web do

      desc "invoke with UNTIL='16:00' REASON='a database upgrade'"
      task :disable, :roles => :web do
        # invoke with
        # UNTIL="16:00 MST" REASON="a database upgrade" cap deploy:web:disable

        require 'erb'
        deadline, reason = ENV['UNTIL'], ENV['REASON']
        erb_file = File.expand_path("../../../../../app/views/layouts/maintenance.html.erb", __FILE__)
        maintenance = ERB.new(File.read(erb_file)).result(binding)

        put maintenance, "#{shared_path}/system/maintenance.html", :mode => 0644
      end

      desc "enable web access"
      task :enable do
        run "rm -f #{shared_path}/system/maintenance.html"
      end

    end

  end

end
