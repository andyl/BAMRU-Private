Capistrano::Configuration.instance(:must_exist).load do

  namespace :backup do

    namespace :generate do

      desc "Backup all Targets"
      task :all do
        run "cd #{current_path} && rake ops:backup:all"
      end

      desc "Backup System Directory"
      task :sysdir do
        run "cd #{current_path} && rake ops:backup:sysdir"
      end

      desc "Backup Database"
      task :db do
        run "cd #{current_path} && rake ops:backup:db"
      end

    end

  end

end

