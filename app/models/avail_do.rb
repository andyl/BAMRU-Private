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
      quarter_start = Time.parse("Jan #{year}") + (quarter-1).quarters
      day = quarter_start + (week-1).weeks + 8.hours
      day = day - 1.week if quarter_start.wday == 3
      day = day - 1.week if year.to_i >= 2015
      adj_factor = case day.wday
        when 0 then 2
        when 1 then 1
        when 2 then 0
        when 3 then 6
        when 4 then 5
        when 5 then 4
        when 6 then 3
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
#  id         :integer          not null, primary key
#  member_id  :integer
#  year       :integer
#  quarter    :integer
#  week       :integer
#  typ        :string(255)
#  comment    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

