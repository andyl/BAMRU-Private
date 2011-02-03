require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'rspec/core/rake_task'

def break() puts '*' * 60; end

task :default => :msg

task :msg do
  puts "Use 'rake -T' to see rake options"
end

desc "Run the development server"
task :run_server do
  system "xterm_title '<thin> #{File.basename(`pwd`).chomp}@#{ENV['SYSNAME']}:9393'"
  system "touch tmp/restart.txt"
  system "shotgun config.ru -s thin -o 0.0.0.0"
end
task :run => :run_server

desc "Run console with live environment"
task :console do
  require 'irb'
  require 'irb/completion'
  require 'config/environment'
  ARGV.clear
  IRB.start
end
task :con => :console

namespace :db do

  task :environment do
    require 'config/environment'
  end

  desc "Remove all databases"
  task :drop do
    Dir["*/*.sqlite3"].each {|f| puts "Dropping #{f}"; File.delete(f)}
  end

  desc "Run database migration"
  task :migrate => :environment do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  desc "Remove all data from database"
  task :reset => :environment do
    puts "Removing all database records"
    Action.delete_all_with_validation
  end

  desc "Load seed data"
  task :seed => [:environment, :reset] do
    puts "Loading Seed Data"
    require 'db/seed'
  end

  desc "Load CSV data"
  task :csv => :environment do
    file = ENV['CSV'] || "data/csv/working_copy.csv"
    puts "Loading CSV Data"
    puts " > using data from '#{file}'"
    puts " > run with 'CSV=<filename>' to use another file"
    csv_load = CsvLoader.new(file)
    puts "Processed #{csv_load.num_input} records."
    puts "Loaded #{csv_load.num_successful} records successfully."
    ms = csv_load.num_malformed == 0 ? "" : "(view at #{MALFORMED_FILENAME})"
    puts "Found #{csv_load.num_malformed} malformed records. #{ms}"
    is = csv_load.num_invalid == 0 ? "" : "(view at #{INVALID_FILENAME})"
    puts "Found #{csv_load.num_invalid} invalid records. #{is}"
  end

  desc "Show database statistics"
  task :stats => :environment do
    mc, tc = Action.meetings.count, Action.trainings.count
    ec, nc = Action.events.count, Action.non_county.count
    puts "There are a total of #{Action.count} records in the database."
    puts "(#{mc} meetings, #{tc} trainings, #{ec} events, #{nc} non-county)"
  end

end

desc "Run all specs"
task :spec do
  cmd = "rspec -O spec/spec.opts spec/**/*_spec.rb"
  puts "Running All Specs"
  puts cmd
  system cmd
end

namespace :spec do
  desc "Show spec documentation"
  task :doc do
    cmd = "rspec -O spec/spec.opts --format documentation spec/**/*_spec.rb"
    puts "Generating Spec documentation"
    puts cmd
    system cmd
  end

  desc "Generate HTML documentation"
  task :html do
    outfile = '/tmp/spec.html'
    cmd = "rspec -O spec/spec.opts --format html spec/**/*_spec.rb > #{outfile}"
    puts "Generating HTML documentation"
    puts cmd
    system cmd
    puts "HTML documentation written to #{outfile}"
  end

  task :rcov_cleanup do
    system "rm -rf coverage"
  end

  desc ""
  RSpec::Core::RakeTask.new(:run_rcov) do |t|
    t.rcov = true
    t.rcov_opts = %q[--exclude "/home" --exclude "spec"]
    t.verbose = true
  end

  desc "Generate coverage report"
  task :rcov => [:rcov_cleanup, :run_rcov] do
    puts "Rcov generated - view at 'coverage/index.html'"
  end

end

task :rdoc_cleanup do
  system "rm -rf doc"
end

desc "Generate Rdoc"
task :rdoc => :rdoc_cleanup do
  system "rdoc lib/*.rb README.rdoc -N --main README.rdoc"
  puts "Rdoc generated - view at 'doc/index.html'"
end

desc "Remove all Rcov and Rdoc data"
task :cleanup => ['spec:rcov_cleanup', :rdoc_cleanup] do
  puts "Done"
end
task :clean => :cleanup
