#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'rake'

require File.expand_path('../config/application', __FILE__)
require File.expand_path('../config/environment', __FILE__)

Zn::Application.load_tasks

desc "Run the development server"
task :run_server do
  system "xterm_title '<foreman-dev> #{File.basename(`pwd`).chomp}@#{ENV['SYSNAME']}'"
  system "touch tmp/restart.txt"
  system "bundle exec foreman start -f Procfile.dev"
end
task :run => :run_server
