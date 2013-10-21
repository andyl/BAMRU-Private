require 'csv'

module Export
  class Phones
    def self.all
      phoarr = Phone.all.map do |pho|
        [
          pho.member.first_name,
          pho.member.last_name,
          pho.typ,
          pho.number,
          pho.pagable,
          pho.position
        ]
      end
      CSV.open('/tmp/phones.csv', 'w') do |csv|
        phoarr.each do |mem|
          csv << mem
        end
      end
    end
  end
end
