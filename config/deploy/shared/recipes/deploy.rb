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

        on_rollback { rm "#{shared_path}/system/maintenance.html" }

        require 'erb'
        deadline, reason = ENV['UNTIL'], ENV['REASON']
        maintenance = ERB.new(File.read("#{current_path}/app/views/layouts/maintenance.erb")).result(binding)

        put maintenance, "#{shared_path}/system/maintenance.html", :mode => 0644
      end

      desc "enable web access"
      task :enable do
        rm "#{shared_path}/system/maintenance.html"
      end

    end

  end

end
