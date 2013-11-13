require 'csv'

module Export
  class Events
    def self.all
      ev_arr = Event.all.map do |eve|
        parts = eve.periods.map do |per|
        end
        [
          eve.typ,
          eve.title,
          eve.leaders,
          eve.description,
          eve.location,
          eve.lat,
          eve.lon,
          eve.start,
          eve.finish,
          eve.all_day,
          eve.published,
        ]
      end
      CSV.open('/tmp/events.csv', 'w') do |csv|
        ev_arr.each do |mem|
          csv << mem
        end
      end
    end
  end
end
