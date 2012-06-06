Capistrano::Configuration.instance(:must_exist).load do

  namespace :data do

    namespace :upload do

      desc "Upload yaml_db file"
      task :db, :role => :db do
        yml_file = File.expand_path('../../../../db/data.yml', File.dirname(__FILE__))
        if File.exist? yml_file
          put File.read(yml_file), "#{current_path}/db/data.yml"
        else
          puts "Database file doesn't exist (#{yml_file})"
        end
      end

      desc "Upload system directory"
      task :sysdir do
        sys_path = File.expand_path('../../../../public/system', File.dirname(__FILE__))
        if Dir.exist? sys_path
          puts "Uploading system directory - this might take awhile..."
          system "scp -rq #{sys_path} #{proxy}:#{current_path}/public"
        else
          puts "System directory doesn't exist (#{sys_path})"
        end
      end

    end

    namespace :import do

      desc "Import the yaml_db file"
      task :import, :role => :db do
        run "cd #{current_path} && rake db:data:load"
      end

    end

  end

end

