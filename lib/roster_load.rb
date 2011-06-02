require 'open-uri'
require 'json'
require 'csv-mapper'

class RosterLoad

  JSON_URL = "http://roster.alt55.com/BAMRU-roster.json"
  DO_ASSIG = "http://roster.alt55.com/do_assignments.csv"

  def self.parse
    json_data = open(JSON_URL).read
    parsed_data = JSON.parse(json_data, :symbolize_names => true)
  end

  def self.load_csv
    csv_data = open(DO_ASSIG).read
    File.open('/tmp/x.csv', 'w') {|f| f.print csv_data}
    CsvMapper::import(csv_data, :type => :io) do
      hash = {
              :year    => year,
              :quarter => quarter,
              :week    => week,
              :name    => name
      }
      DoAssignment.create(hash)
    end
  end

  def self.import(member_array)
    member_array.each do |w|
      Member.create(w)
    end
    load_csv
  end

end
