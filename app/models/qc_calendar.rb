require 'open-uri'

class QcCalendar

  def self.csv_resync
    result = open('http://bamru.org/csv_resync')
    timestamp = Time.now.strftime("%m-%d %H:%M:%S")
    puts "#{timestamp} - Doing CSV Resync - Status = #{result.string}"
  end

end
