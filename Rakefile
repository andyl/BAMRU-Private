#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Zn::Application.load_tasks

desc "Run the development server"
task :run_server do
  system "xterm_title '<rails> #{File.basename(`pwd`).chomp}@#{ENV['SYSNAME']}:3000'"
  system "touch tmp/restart.txt"
  system "rails server"
end
task :run => :run_server
