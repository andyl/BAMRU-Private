Capistrano::Configuration.instance(:must_exist).load do

  namespace :data do

    desc "Perform all data initialization tasks"
    task :init do
      data.upload.sysdir
      data.upload.db
      data.import.db
    end

    namespace :upload do

      desc "Upload system directory"
      task :sysdir do
        sys_path = File.expand_path('../../../../public/system', File.dirname(__FILE__))
        if Dir.exist? sys_path
          puts "Uploading system directory - this might take awhile. (#{Time.now.strftime('%H:%M:%S')})"
          system "scp -rq #{sys_path} #{user}@#{proxy}:#{shared_path}"
          puts "Uploading finished. (#{Time.now.strftime('%H:%M:%S')})"
        else
          puts "System directory doesn't exist (#{sys_path})"
        end
      end

      desc "Upload yaml_db file"
      task :db, :role => :db do
        yml_file = File.expand_path('../../../../db/data.yml', File.dirname(__FILE__))
        if File.exist? yml_file
          put File.read(yml_file), "#{current_path}/db/data.yml"
        else
          puts "Database file doesn't exist (#{yml_file})"
        end
      end

    end

    namespace :import do

      desc "Import the yaml_db file"
      task :db, :role => :db do
        run "cd #{current_path} && rake db:data:load"
      end

    end

  end

end

