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
  Org.create(:name => "BAMRU")
  Rake::Task['photos'].invoke
  Rake::Task['cert_image_load'].invoke
end

desc "Run the Jasmine Server"
task :jas do
  system "xterm_title '<jasmine> #{File.basename(`pwd`).chomp}@#{ENV['SYSNAME']}:8888'"
  Rake::Task['jasmine'].invoke
end

desc "Run the Guard Server"
task :guard do
  system "xterm_title '<guard> #{File.basename(`pwd`).chomp}@#{ENV['SYSNAME']}'"
  system "bundle exec guard"
end

desc "Reload Photos"
task :photos do
  require 'config/environment'
  puts "Reloading Photos (this might take awhile...)"
  Photo.destroy_all
  Dir.glob('./db/jpg/*jpg').sort.each do |i|
    username = File.basename(i)[0..-7].gsub('_','.')
    member = Member.where(:user_name => username).first
    if member
      member.photos.create(:image => File.open(i))
      member.save
    end
  end
end

desc "Download Certs"
task :cert_download do
  base_dir = File.dirname(File.expand_path(__FILE__))
  doc_dir  = base_dir + '/db/docs'
  require 'config/environment'
  puts "Downloading all Cert files"
  Dir.chdir(doc_dir)
  system "rm -f *jpg *pdf"
  Cert.with_docs.each do |c|
    system "wget #{c.doc_url}"
  end
end

desc "Convert PDF Certs to JPG"
task :cert_convert do
  base_dir = File.dirname(File.expand_path(__FILE__))
  doc_dir  = base_dir + '/db/docs'
  require 'config/environment'
  puts "Converting PDF Cert files to JPG"
  Cert.with_pdfs.each do |c|
    puts "> Converting #{c.doc_path}"
    system "convert -density 300 #{c.doc_path} #{c.final_doc_path}"
  end
end

desc "Load Cert Images"
task :cert_image_load do
  require 'config/environment'
  puts "Loading CERT Images"
  Cert.with_docs.each do |c|
    puts "Updating #{c.final_doc_path}"
    c.update_attributes(:document => File.open(c.final_doc_path))
  end
end

