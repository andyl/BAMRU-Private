require 'open-uri'
require 'json'

class RosterLoad
  JSON_URL = "http://roster.alt55.com/BAMRU-roster.json"

  def self.parse
    json_data = open(JSON_URL).read
    parsed_data = JSON.parse(json_data, :symbolize_names => true)
  end

  def self.import(member_array)
    member_array.each do |w|
      Member.create(w)
    end
  end

end
