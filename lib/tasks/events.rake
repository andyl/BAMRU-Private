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
    puts "     Specials: #{Event.specials.count}"
    puts "     Periods: #{Period.count}"
    puts "Participants: #{Participant.count}"
  end

  desc "Load CSV data"
  task :load => :reset do
    load_events
    Rake::Task["events:count"].invoke
  end

  def load_events
    csv_data = get_file("http://bamru.org/calendar.csv")
    params   = csv_to_params(csv_data)
    params.each {|p| Event.create(p)}
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
      val.delete("leaders")
      val["typ"] = val.delete("kind")
      val["typ"] = "special" if val["typ"] == "other"
      val
    end
    array_of_hashes
  end

  def load_record(row)
    puts row.inspect
  end

end
