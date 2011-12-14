class AvailDo < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member


  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----


  # ----- Class Methods -----
  def self.find_or_new(hash)
    where(hash).first || new(hash)
  end

  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end

  def start_time
      day = Time.parse("Jan #{year}") + (quarter-1).quarters + (week-1).weeks + 8.hours
      adj_factor = case day.wday
        when 0 : 2
        when 1 : 1
        when 2 : 0
        when 3 : 6
        when 4 : 5
        when 5 : 4
        when 6 : 3
      end
      day + adj_factor.days
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

