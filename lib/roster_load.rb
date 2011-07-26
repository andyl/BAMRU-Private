require 'open-uri'
require 'json'
require 'csv-mapper'

class RosterLoad

  JSON_URL   = "http://roster.alt55.com/BAMRU-roster.json"
  DO_ASSIG   = "http://roster.alt55.com/do_assignments.csv"
  JSON_FILE  = "/home/aleak/dl/BAMRU-roster.json"
  ZIP_FILE   = "/home/aleak/dl/BAMRU-roster.zip"

  def self.zip_dir
    ZIP_FILE.split('.').first
  end

  def self.load_from_zip(zip = ZIP_FILE)
    basenam = File.basename(zip).split('.').first
    basedir = File.dirname(zip)
    cmd = "cd #{basedir}; rm -r -f #{basenam}; unzip #{zip}"
    puts cmd
    system cmd
    json_data = open("#{basedir}/#{basenam}/data.json").read.gsub('&quot;', '"')
    parsed_data = JSON.parse(json_data, :symbolize_names => true)
    parsed_data
  end

  def self.parse_from_file(file = JSON_FILE)
    json_data = open(file).read.gsub('&quot;', '"')
    parsed_data = JSON.parse(json_data, :symbolize_names => true)
    parsed_data
  end

  def self.parse_from_url(url = JSON_URL)
    json_data = open(url).read
    parsed_data = JSON.parse(json_data, :symbolize_names => true)
    parsed_data
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
      DoAssignment.create(hash) unless r.nil? || r.name.nil? || r.name.blank?
    end
  end

  def self.import(member_array)
    member_array.each do |w|
      x = Member.new(w)
      x.check_first_name_for_title
      x.set_username_and_name_fields
      x.set_pwd
      x.save(:validate => false)
      x.phones.each_with_index {|v,i| v.update_attributes(:position => i+1)}
      x.emails.each_with_index {|v,i| v.update_attributes(:position => i+1)}
      x.addresses.each_with_index {|v,i| v.update_attributes(:position => i+1)}
      x.emergency_contacts.each_with_index {|v,i| v.update_attributes(:position => i+1)}
      x.other_infos.each_with_index {|v,i| v.update_attributes(:position => i+1)}
    end
    load_csv
  end

end
