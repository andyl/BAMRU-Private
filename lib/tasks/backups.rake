require 'rake_util'

include RakeUtil

# ----- Rake Tasks -----

namespace :ops do
  namespace :backup do

    desc "Backup Wiki"
    task :wiki => 'environment' do
      puts "WIKI Backup TBD"
    end

    desc "Backup Database and System"
    task :db_and_system do
      puts "Database/System Backup TBD"
    end

  end
end
