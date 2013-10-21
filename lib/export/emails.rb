require 'csv'

module Export
  class Emails
    def self.all
      emaarr = Email.all.map do |ema|
        [
          ema.member.first_name,
          ema.member.last_name,
          ema.typ,
          ema.address,
          ema.pagable,
          ema.position
        ]
      end
      CSV.open('/tmp/emails.csv', 'w') do |csv|
        emaarr.each do |mem|
          csv << mem
        end
      end
    end
  end
end
