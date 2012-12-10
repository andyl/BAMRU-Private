require 'open-uri'
require 'csv'

namespace :events do

  task :environment do
    require File.expand_path('../../../config/environment', __FILE__)
  end

  desc "Delete all events"
  task :reset => :environment do
    puts "Clearing old event data"
    Event.destroy_all
    Participant.destroy_all
    Period.destroy_all
    EventReport.destroy_all
    Member.guests.each {|guest| guest.destroy}
  end

  desc "Count Event Objects"
  task :count => :environment do
    puts "      Events: #{Event.count}"
    puts "     Meetings: #{Event.meetings.count}"
    puts "    Trainings: #{Event.trainings.count}"
    puts "   Operations: #{Event.operations.count}"
    puts "  Communities: #{Event.communities.count}"
    puts "      Socials: #{Event.socials.count}"
    puts "     Periods: #{Period.count}"
    puts "Participants: #{Participant.count}"
  end

  desc "Preview CSV data from db/2010.csv"
  task :prev10 => [:environment] do preview_csv("2010"); end

  desc "Load CSV data from db/2010.csv"
  task :load10 => [:environment] do load_csv("2010"); end

  def load_csv_file(file_name)
    tgt_file = File.expand_path("../../../db/#{file_name}.csv", __FILE__)
    csv_data = File.read(tgt_file)
    csv_to_params(csv_data)
  end

  def preview_csv(file_name)
    rows = load_csv_file(file_name)
    preview_csv_events(rows)
    preview_csv_members(rows)
  end

  def load_csv(file_name)
    rows = load_csv_file(file_name)
    load_csv_events(rows)
    #load_csv_members(rows)
  end

  def match_events(rows)
    matched   = []
    unmatched = []
    rows.each do |row|
      if Event.on_day(row["start"]).where(:typ => row["typ"]).empty?
        unmatched << row
      else
        matched << row
      end
    end
    return matched, unmatched
  end
  
  def preview_csv_events(rows)
    matched, unmatched = match_events(rows)
    puts "MATCHED EVENTS (#{matched.length}):"
    matched.each {|row| puts "> #{row["start"]} #{row["typ"].ljust(10)} #{row["title"]}"}
    puts "\nUNMATCHED EVENTS (#{unmatched.length}):"
    unmatched.each {|row| puts "> #{row["start"]} #{row["typ"].ljust(10)} #{row["title"]}"}
    puts "\n--END--"
  end
  
  def match_members(rows)
    int_keys = rows.first.keys
    keys = int_keys.select do |x|
      ! %w(title location leaders start finish description typ).include?(x)
    end
    matched = []; unmatched = []
    keys.each do |key|
      next unless key
      last, first = key.split(' - ')
      username    = "#{first.strip.downcase}_#{last.strip.downcase}"
      if Member.where(user_name: username).empty?
        unmatched << key
      else
        matched << key
      end
    end
    return matched, unmatched
  end

  def preview_csv_members(rows)
    matched, unmatched = match_members(rows)
    puts "\nMATCHED MEMBERS (#{matched.length}):"
    matched.each {|key| puts "> #{key}"}
    puts "\nUNMATCHED MEMBERS (#{unmatched.length}):"
    unmatched.each {|key| puts "> #{key}"}
    puts "\n--END--"
  end
  
  def update_meeting_time(event)
    return unless event.typ == "meeting"
    event.start   = event.start + 19.hours + 30.minutes
    event.finish  = event.start + 2.hours
    event.all_day = false
    event.save
  end
  
  def load_csv_events(rows)
    matched, unmatched = match_events(rows)
    puts "Loading #{unmatched.length} unmatched events."
    unmatched.each do |row|
      event = Event.create(row)
      update_meeting_time(event)
    end
  end
  
  def load_csv_members(event_rows)
    matched, unmatched = match_members(event_rows)
    member_keys = matched + unmatched
    puts "Creating #{unmatched.length} guests."
    unmatched.each do |guest|
      guest["typ"] = "G"
      Member.create guest
    end
    event_rows.each do |row|
      event = get_event(row)
      period = find_or_create_period(event)
      member_keys.each do |member_key|
        next if row[member_key] == ""
        # TODO finish this !!! (DEC 10) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        #    calculate check-in, check-out time
        #    add the participant
      end
    end
  end

  desc "Load CSV data from BAMRU.org"
  task :org => [:environment, :reset] do
    load_events
    Rake::Task["events:count"].invoke
  end

  def load_events
    Time.zone = "Pacific Time (US & Canada)"
    csv_data  = get_file("http://bamru.org/calendar.csv")
    rows = csv_to_params(csv_data)
    rows.each do |row|
      row["published"] = true
      event = Event.create(row)
      update_meeting_time(event)
    end
  end

  def get_file(url)
    puts "Loading data from #{url}"
    open(url).read
  end

  def csv_to_params(string)
    array = CSV.parse(string)
    headers = array.shift
    array_of_hashes = array.map do |row|
      val = Hash[*headers.zip(row).flatten]
      if val["kind"].try(:downcase) == "meeting"
        if val["location"] == "Redwood City"
          val["lat"] = "37.4888"
          val["lon"] = "-122.2305"
        end
        if val["location"] == "Castro Valley"
          val["lat"] = "37.7207"
          val["lon"] = "-122.0962"
        end
      end
      val["typ"] = val.delete("kind").downcase
      val["typ"] = "community" if %w(outreach other).include? val["typ"]
      val
    end
    array_of_hashes
  end

  def load_record(row)
    puts row.inspect
  end

end
