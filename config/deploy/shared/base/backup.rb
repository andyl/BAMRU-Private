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

    namespace :download do

        desc "Download all backups"
        task :all do
          sysdir
          db
          puts "All backups downloaded."
        end

        desc "Download system backups"
        task :sysdir do
          puts "Download system directory backups - this might take awhile. (#{Time.now.strftime('%H:%M:%S')})"
          cmd = "rsync -av #{user}@bamru.org:.backup/bnet/bamru1/sysdir/ ~/.backup/bnet/bamru1/sysdir"
          puts cmd
          system cmd
          puts "Downloading finished. (#{Time.now.strftime('%H:%M:%S')})"
        end

        desc "Download db backups"
        task :db do
          puts "Download database backups. (#{Time.now.strftime('%H:%M:%S')})"
          cmd = "rsync -av #{user}@bamru.org:.backup/bnet/bamru1/db/ ~/.backup/bnet/bamru1/db"
          puts cmd
          system cmd
          puts "Downloading finished. (#{Time.now.strftime('%H:%M:%S')})"
        end

    end

  end

end

