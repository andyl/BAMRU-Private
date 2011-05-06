# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Bnet::Application.load_tasks

desc "Run the development server"
task :run_server do
  system "xterm_title '<rails> #{File.basename(`pwd`).chomp}@#{ENV['SYSNAME']}:9393'"
  system "touch tmp/restart.txt"
  system "rails server"
end
task :run => :run_server

