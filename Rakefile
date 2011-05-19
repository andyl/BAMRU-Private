#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Zn::Application.load_tasks

require 'lib/shared/tasks/rake_tasks'

desc "Run the development server"
task :run_server do
  system "xterm_title '<rails> #{File.basename(`pwd`).chomp}@#{ENV['SYSNAME']}:3000'"
  system "touch tmp/restart.txt"
  system "rails server"
end
task :run => :run_server

desc "Import JSON data"
task :import do
system "xterm_title 'DATA IMPORT'"
  system "rm db/*sqlite3"
  system "rm -rf public/system"
  system "rake db:migrate"
  system "rake db:migrate RAILS_ENV=test"
  require 'config/environment'
  require 'lib/roster_load'
  RosterLoad.import(RosterLoad.parse)
end
