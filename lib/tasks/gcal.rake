namespace :gcal do

  def exit_with(msg)
    puts "Error: #{msg}"
    exit
  end

  def find_event_id
    exit_with("No EVENT_ID") unless event_id = ENV["EVENT_ID"]
    event_id
  end

  def find_event
    event_id = find_event_id
    exit_with("No records (id=#{event_id})") unless event = Event.find_by_id(event_id)
    event
  end

  task :environment do
    require 'rubygems'
    require 'bundler/setup'
    require File.expand_path('../../../config/environment', __FILE__)
    #require File.expand_path('../../../lib/gcal_sync', __FILE__)
  end

  desc "Count number of Google Calendar records"
  task :count => :environment  do
    num = QcGcal.count_gcal_events
    puts "Number of gCal events: #{num}"
  end

  desc "Sync All Calendar Data with Google Calendar"
  task :sync => :environment  do
    QcGcal.sync
  end

  desc "Create a Gcal Event (EVENT_ID=<id>)"
  task :create => :environment do
    QcGcal.create_event(find_event)
  end

  desc "Update a Gcal Event (EVENT_ID=<id>)"
  task :update => :environment  do
    QcGcal.update_event(find_event)
  end

  desc "Delete a Gcal Event  (EVENT_ID=<id>)"
  task :delete => :environment  do
    QcGcal.delete_event(find_event_id)
  end

end