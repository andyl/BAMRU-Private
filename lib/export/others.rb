require 'csv'

module Export
  class Others
    def self.all
      memarr = Member.all.map do |mem|
        [
          mem.first_name,
          mem.last_name,
          mem.ham,
          mem.v9
        ]
      end
      CSV.open('/tmp/others.csv', 'w') do |csv|
        memarr.each do |mem|
          csv << mem
        end
      end
    end
  end
end
