require 'csv'

module Export
  class Events
    def self.all
      per_arr = []
      par_arr = []
      ev_arr = Event.all.map do |eve|
        eve.periods.each do |per|
          per.participants.each do |par|
            par_arr << [
              par.member.try(:emails).try(:first).try(:address),
              par.period_id,
              par.en_route_at,
              par.return_home_at,
              par.signed_in_at,
              par.signed_out_at,
              par.ol,
              par.ahc
            ]
          end
          per_arr << [
            per.id,
            per.event_id,
            per.position
          ]
        end
        [
          eve.id,
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
      CSV.open('/tmp/periods.csv', 'w') do |csv|
        per_arr.each do |per|
          csv << per
        end
      end
      CSV.open('/tmp/participants.csv', 'w') do |csv|
        par_arr.each do |par|
          csv << par
        end
      end
    end
  end
end
