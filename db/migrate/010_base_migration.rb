class BaseMigration < ActiveRecord::Migration
  # tables...
  # user, address, phone, role, photo, email, 
  # mpa (member personal availabliity) , doa (duty officer availability)
  # page_log
  def self.up
    create_table :actions do |t|
      t.string   :digest
      t.string   :kind,     :default => "event"
      t.string   :title
      t.string   :location, :default => "TBA"
      t.string   :leaders,  :default => "TBA"
      t.date     :start,    :default => Time.now
      t.date     :finish
      t.text     :description
      t.boolean  :first_in_year, :default => false
      t.timestamps
    end
  end
end
