require 'csv'

module Export
  class Addresses
    def self.all
      adrarr = Address.all.map do |adr|
        [
          adr.member.first_name,
          adr.member.last_name,
          adr.typ,
          adr.address1,
          adr.address2,
          adr.city,
          adr.state,
          adr.zip,
          adr.position
        ]
      end
      CSV.open('/tmp/addresses.csv', 'w') do |csv|
        adrarr.each do |mem|
          csv << mem
        end
      end
    end
  end
end
