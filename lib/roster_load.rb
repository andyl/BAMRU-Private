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
    File.open("/tmp/x.csv", 'w') {|f| f.print csv_data}
    result = CsvMapper::import("/tmp/x.csv") do
      read_attributes_from_file
    end
    result.each do |r|
      hash = {
              :year    => r.year,
              :quarter => r.quarter,
              :week    => r.week,
              :name    => r.name
      }
      DoAssignment.create(hash) unless r.name.nil? || r.name.blank?
    end
  end

  def self.import(member_array)
    member_array.each do |w|
      x = Member.create(w)
      x.phones.each_with_index {|v,i| v.update_attributes(:position => i+1)}
      x.emails.each_with_index {|v,i| v.update_attributes(:position => i+1)}
      x.addresses.each_with_index {|v,i| v.update_attributes(:position => i+1)}
      x.emergency_contacts.each_with_index {|v,i| v.update_attributes(:position => i+1)}
      x.other_info.each_with_index {|v,i| v.update_attributes(:position => i+1)}
    end
    load_csv
  end

end
