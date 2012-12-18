require 'open-uri'

class QcCalendar

  def self.csv_resync
    result = open('http://bamru.org/csv_resync')
    puts "Doing CSV Resync - Status = #{result.string}"
  end

end
