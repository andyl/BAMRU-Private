require 'open-uri'
require 'csv'

namespace :events do

  desc "Delete all events"
  task :reset do
    puts "Clearing old event data"
    Event.destroy_all
    Participant.destroy_all
    Period.destroy_all
  end

  desc "Count Event Objects"
  task :count do
    puts "      Events: #{Event.count}"
    puts "     Meetings: #{Event.meetings.count}"
    puts "    Trainings: #{Event.trainings.count}"
    puts "   Operations: #{Event.operations.count}"
    puts "  Communities: #{Event.communities.count}"
    puts "      Socials: #{Event.socials.count}"
    puts "     Periods: #{Period.count}"
    puts "Participants: #{Participant.count}"
  end

  desc "Load CSV data"
  task :load => :reset do
    load_events
    Rake::Task["events:count"].invoke
  end

  def load_events
    Time.zone = "Pacific Time (US & Canada)"
    csv_data  = get_file("http://bamru.org/calendar.csv")
    rows = csv_to_params(csv_data)
    rows.each do |row|
      event = Event.create(row)
      if event.typ == "meeting"
        event.start   = event.start + 19.hours + 30.minutes
        event.finish  = event.start + 2.hours
        event.all_day = false
        event.save
      end
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
      val["typ"] = val.delete("kind")
      val["typ"] = "community" if val["typ"] == "other"
      val
    end
    array_of_hashes
  end

  def load_record(row)
    puts row.inspect
  end

end
