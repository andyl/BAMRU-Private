require 'open-uri'
require 'csv'

class DataSrc
  def hash_data(string = nil)
    data_string = string || csv_data
    array = CSV.parse(data_string)
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
end

class UrlSrc < DataSrc
  def initialize(url)
    @url = url
  end

  def csv_data
    puts "Loading data from #{@url}"
    open(@url).read
  end
end

class FileSrc < DataSrc
  def initialize(file_name)
    @file_name = file_name
  end

  def csv_data
    puts "Loading data from #{@file_name}.csv"
    tgt_file = File.expand_path("../../../db/#{@file_name}.csv", __FILE__)
    File.read(tgt_file)
  end

end

class Rows
  def initialize(rows)
    @rows = rows
  end

  def load_events(default_opts = {})
    Time.zone = "Pacific Time (US & Canada)"
    @rows.each do |row|
      row.merge! default_opts
      event = Event.create(row)
      update_meeting_time(event)
    end
  end

  private

  def update_meeting_time(event)
    return unless event.typ == "meeting"
    event.start   = event.start + 19.hours + 30.minutes
    event.finish  = event.start + 2.hours
    event.all_day = false
    event.save
  end
end

class Row

end

def preview_csv(file_name)
  rows = FileSrc.new(file_name).hash_data
  preview_csv_events(rows)
  preview_csv_members(rows)
end

def load_csv(file_name)
  rows = FileSrc.new(file_name).hash_data
  load_csv_events(rows)
  load_csv_members(rows)
end

def get_user_name(key)
  last, first = key.split(' - ')
  "#{first.strip.downcase}_#{last.strip.downcase}"
end

def get_member(key)
  user_name = get_user_name(key)
  Member.where(user_name: user_name).first
end

def get_event(row)
  Time.zone = "Pacific Time (US & Canada)"
  Event.on_day(row["start"]).where(:typ => row["typ"]).first
end

def match_events(rows)
  matched   = []
  unmatched = []
  rows.each do |row|
    if get_event(row)
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
    member = get_member(key)
    if member
      matched << key
    else
      unmatched << key
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

def load_csv_events(rows)
  matched, unmatched = match_events(rows)
  puts "Creating #{unmatched.length} unmatched events."
  unmatched.each do |row|
    event = Event.create(row)
    update_meeting_time(event)
  end
end

def find_or_create_period(event)
  event.periods.first || event.periods.create
end

def load_csv_members(event_rows)
  matched, unmatched = match_members(event_rows)
  member_keys = matched + unmatched
  puts "Creating #{unmatched.length} guests."
  unmatched.each do |guest|
    opts = {
      typ: 'G',
      user_name: get_user_name(guest)
    }
    Member.create opts
  end
  puts "Creating #{member_keys.length} participants."
  event_rows.each do |row|
    event  = get_event(row)
    next if event.nil?
    period = find_or_create_period(event)
    member_keys.each do |member_key|
      next if [nil, "", []].include? row[member_key]
      member = get_member(member_key)
      check_in = event.start + 9.hours
      hours = row[member_key].to_f
      check_out = check_in + hours.hours
      next if member.nil?
      opts = {
        member_id: member.id,
        period_id: period.id,
        signed_in_at: check_in,
        signed_out_at: check_out
      }
      Participant.create(opts)
    end
  end
end

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
    puts "     Members: #{Member.count}"
    puts "      Guests: #{Member.guests.count}"
    puts "Participants: #{Participant.count}"
  end

  desc "Preview CSV data from db/2010.csv"
  task :prev_10 => [:environment] do
    #FileData.new("2010").preview_events
    preview_csv("2010");
  end

  desc "Load CSV data from db/2010.csv"
  task :load_10 => [:environment] do
    #FileData.new("2010").load_events
    load_csv("2010")
    Rake::Task["events:count"].invoke
  end

  desc "Load CSV data from BAMRU.org"
  task :load_org => [:environment, :reset] do
    rows = UrlSrc.new("http://bamru.org/calendar.csv").hash_data
    Rows.new(rows).load_events({published: true})
    Rake::Task["events:count"].invoke
  end

end
