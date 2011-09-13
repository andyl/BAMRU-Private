class AvailDo < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member


  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----


  # ----- Class Methods -----
  def self.find_or_new(hash)
    puts hash.inspect
    where(hash).first || new(hash)
  end

  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end

  def start_time
    Time.parse("Jan #{year}") + (quarter-1).quarters + (week-1).weeks + 3.days + 8.hours
  end

  def end_time
    start_time + 1.week - 1.minute
  end

end

# == Schema Information
#
# Table name: avail_dos
#
#  id         :integer         not null, primary key
#  member_id  :integer
#  year       :integer
#  quarter    :integer
#  week       :integer
#  typ        :string(255)
#  comment    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

