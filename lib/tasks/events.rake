require 'open-uri'
require 'csv'

EVENT_FIELDS = %w(title location leaders lat lon start finish description typ)

class DataSrc
  def hash_data(string = nil)
    data_string = string || csv_data
    array = CSV.parse(data_string)
    headers = array.shift
    array_of_hashes = array.map do |row|
      val = gen_hash(headers, row)
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

  private

  def gen_hash(headers, row)
    Hash[*headers.zip(row).flatten]
  end
end

class UrlSrc < DataSrc
  def initialize(url)
    puts "Loading data from #{url}"
    @url = url
  end

  def csv_data
    open(@url).read
  end
end

class FileSrc < DataSrc
  def initialize(file_name)
    puts "Loading data from #{file_name}.csv"
    @file_name = file_name
  end

  def csv_data
    tgt_file = File.expand_path("../../../db/#{@file_name}.csv", __FILE__)
    File.read(tgt_file)
  end

end

class EventRows
  def initialize(rows)
    @rows = rows
  end

  def preview
    puts "MATCHED EVENTS (#{matched.length}):"
    matched.each {|row| EventRow.new(row).puts}
    puts "\nUNMATCHED EVENTS (#{unmatched.length}):"
    unmatched.each {|row| EventRow.new(row).puts}
    puts "\n--END--"
    self
  end

  def load(default_opts = {})
    puts "Creating #{unmatched.length} unmatched events."
    unmatched.each { |row| EventRow.new(row).create(default_opts) }
    puts "Merging #{matched.length} matched events."
    matched.each do |row|
      current = EventRow.new(row).fetch
      latlon = row["lat"].blank? ? {} : {lat: row["lat"], lon: row["lon"]}
      newdes = current.description + " >> " + row["description"]
      opts = {description: newdes}.merge latlon
      current.update_attributes opts
    end
    self
  end

  private

  def row_set
    @row_set ||= split(@rows)
  end

  def matched
    row_set.matched
  end

  def unmatched
    row_set.unmatched
  end

  def split(rows = @rows)
    matched   = []; unmatched = []
    rows.each do |row|
      (EventRow.new(row).fetch ? matched : unmatched) << row
    end
    OpenStruct.new matched: matched, unmatched: unmatched
  end
end

class MemberRows
  def initialize(rows)
    @member_rows = rows
  end

  def preview
    puts "\nMATCHED MEMBERS (#{matched.length}):"
    matched.each {|key| puts "> #{key}"}
    puts "\nUNMATCHED MEMBERS (#{unmatched.length}):"
    unmatched.each {|key| puts "> #{key}"}
    puts "\n--END--"
    self
  end

  def load(default_opts = {})
    puts "Creating #{unmatched.length} guests."
    unmatched.each { |key| MemberRow.new(key).create(default_opts) }
    self
  end

  private

  def row_set
    @row_set ||= split(@member_rows)
  end

  def matched
    row_set.matched
  end

  def unmatched
    row_set.unmatched
  end

  def split(rows = @member_rows)
    tgt_row = rows.max_by {|r| r.length}
    keys = tgt_row.keys.select { |x| ! EVENT_FIELDS.include?(x) }
    matched = []; unmatched = []
    keys.each do |key|
      next unless key
      (MemberRow.new(key).fetch ? matched : unmatched) << key
    end
    OpenStruct.new matched: matched, unmatched: unmatched
  end
end

class ParticipantRows
  def initialize(rows)
    @rows = rows
  end

  def load
    puts "Creating #{member_keys.length} participants."
    @rows.each do |row|
      event_row = EventRow.new(row)
      next unless event_obj = event_row.fetch
      member_keys.each do |member_key|
        next unless event_row.has_hours(member_key)
        check_in   = event_obj.start + 9.hours
        hours      = event_row.hours_for(member_key).to_f
        check_out  = check_in + hours.hours
        member_row = MemberRow.new(member_key)
        next unless member_obj = member_row.fetch
        opts = {
          member_id: member_obj.id,
          period_id: event_row.period.id,
          signed_in_at: check_in,
          signed_out_at: check_out
        }
        Participant.create(opts)
      end
    end
  end

  private

  def member_keys
    tgt_row = @rows.max_by {|r| r.length}
    tgt_row.keys.select {|key| (! (EVENT_FIELDS + [nil]).include?(key))}
  end
end

class EventRow
  def initialize(row)
    @row = row
  end

  def puts
    STDOUT.puts "> #{@row["start"]} #{@row["typ"].ljust(10)} #{@row["title"]}"
  end

  def fetch(row = @row)
    Time.zone = "Pacific Time (US & Canada)"
    @event = Event.on_day(row["start"]).where(:typ => row["typ"]).where(:title => row["title"]).all
    rats = @event.map {|ev| "#{ev.typ}/#{ev.title}/#{ev.start.strftime("%m-%d")}"}.join(" | ")
    STDOUT.puts "ALERT: MULTIPLE HITS #{@event.length} #{rats}" if @event.length > 1
    @event = @event.first
  end
  
  def create(default_opts = {})
    event = Event.create(event_opts(@row).merge(default_opts))
    update_meeting_time(event)
  end

  def event_obj
    @event ||= create
  end

  def period
    @period ||= find_or_create_period(event_obj)
  end

  def has_hours(member_key)
    ! [nil, "", []].include? hours_for(member_key)
  end

  def hours_for(member_key)
    @row[member_key]
  end
  
  private

  def event_opts(hash)
    hash.delete_if {|k,v| ! EVENT_FIELDS.include? k }
  end

  def find_or_create_period(event)
    event.periods.first || event.periods.create
  end
  
  def update_meeting_time(event)
    return event unless event.typ == "meeting"
    event.start   = event.start + 19.hours + 30.minutes
    event.finish  = event.start + 2.hours
    event.all_day = false
    event.save
    event
  end
end

class MemberRow
  def initialize(key)
    @key = key
  end

  def create(default_opts = {})
    opts = {
      typ: 'G',
      user_name: user_name
    }
    Member.create(opts.merge(default_opts))
  end

  def user_name(key = @key)
    last, first = key.split(' - ')
    "#{first.strip.downcase} #{last.strip.downcase}".split(' ').join('_')
  end

  def fetch
    user_name = user_name(@key)
    Member.where(user_name: user_name).first
  end
  
end

def common_prev(year)
  src = FileSrc.new(year)
  EventRows.new(src.hash_data).preview
  MemberRows.new(src.hash_data).preview
end

def common_load(year)
  src = FileSrc.new(year)
  EventRows.new(src.hash_data).load
  MemberRows.new(src.hash_data).load
  ParticipantRows.new(src.hash_data).load
  Rake::Task["events:count"].invoke
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
    common_prev("2010")
  end

  desc "Load CSV data from db/2010.csv"
  task :load_10 => [:environment] do
    common_load("2010")
  end

  desc "Preview CSV data from db/2011.csv"
  task :prev_11 => [:environment] do
    common_prev("2011")
  end

  desc "Load CSV data from db/2011.csv"
  task :load_11 => [:environment] do
    common_load("2011")
  end

  desc "Preview CSV data from db/2012.csv"
  task :prev_12 => [:environment] do
    common_prev("2012")
  end

  desc "Load CSV data from db/2012.csv"
  task :load_12 => [:environment] do
    common_load("2012")
  end

  desc "Load CSV data from BAMRU.org"
  task :load_org => [:environment] do
    rows = UrlSrc.new("http://bamru.org/calendar.csv").hash_data
    EventRows.new(rows).load({published: true})
    Rake::Task["events:count"].invoke
  end

end
