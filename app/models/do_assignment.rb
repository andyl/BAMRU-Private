require 'time'

class DoAssignment < ActiveRecord::Base

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
  def avail_members
    AvailDo.where(:year => year, :quarter => quarter, :week => week).
            all.
            map {|a| a.member}.
            sort {|a,b| a.last_name <=> b.last_name}.
            map {|m| m.full_name}.
            uniq
  end

  def start_day
    start_time.strftime("%b #{start_time.day.ordinalize}")
  end

  def end_day
    end_time.strftime("%b #{end_time.day.ordinalize}")
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
# Table name: do_assignments
#
#  id         :integer         not null, primary key
#  org_id     :integer         default(1)
#  year       :integer
#  quarter    :integer
#  week       :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

