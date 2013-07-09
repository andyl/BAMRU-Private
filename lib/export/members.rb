require 'csv'

module Export
  class Members
    def self.all
      memarr = Member.all.map do |mem|
        [
          mem.first_name,
          mem.last_name,
          mem.typ,
          mem.developer,
          mem.photos.first.try(:image).try(:url)
        ]
      end
      CSV.open('/tmp/members.csv', 'w') do |csv|
        memarr.each do |mem|
          csv << mem
        end
      end
    end
  end
end
