Capistrano::Configuration.instance(:must_exist).load do

  namespace :data do

    namespace :upload do

      desc "Upload yaml_db file"
      task :db, :role => :db do
        upload "db/data.yml", "#{release_path}/db/data.yml"
      end

      desc "Upload system directory"
      task :sysdir do
        upload("public/system", "#{release_path}/public", :via=> :scp, :recursive => true)
      end

    end

    namespace :import do

      desc "Import the yaml_db file"
      task :import, :role => :db do
        run "cd #{release_path} && rake db:data:load"
      end

    end

  end

end

