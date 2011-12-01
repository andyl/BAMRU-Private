require 'time'

class DoAssignment < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :primary, :class_name => 'Member'
  belongs_to :backup,  :class_name => 'Member'
  # ----- Callbacks -----

  before_save :set_primary_from_name
  before_save :set_start_and_finish
  before_save :sync_name_and_primary


  # ----- Validations -----

  # ----- Scopes -----
  scope :last_wk, where('start < ?', Time.now - 1.week).where('finish > ?', Time.now - 1.week)
  scope :current, where('start < ?', Time.now).where('finish > ?', Time.now)
  scope :this_wk, where('start < ?', Time.now).where('finish > ?', Time.now)
  scope :next_wk, where('start < ?', Time.now + 1.week).where('finish > ?', Time.now + 1.week)
  scope :pending, where('start < ?', Time.now + 1.week).where('finish > ?', Time.now + 1.week)
  scope :has_backup,  where("backup_id <> ''")
  scope :non_current, where('start > ? OR finish < ?', x = Time.now, x)

  # ----- Class Methods -----
  def self.find_or_new(hash)
    where(hash).first || new(hash)
  end

  # ----- Local Methods-----
  def set_start_and_finish
    self.start  = start_time
    self.finish = end_time
  end

  def sync_name_and_primary
    self.primary_id = nil if self.name.blank?
    self.backup_id  = nil if self.primary_id.blank?
  end

  def avail_members
    AvailDo.where(:year => year, :quarter => quarter, :week => week, :typ => "available").
            all.
            map {|a| a.member}.
            sort {|a,b| a.last_name <=> b.last_name}.
            map {|m| m.full_name}.
            uniq
  end

  def backup_hash
    Member.order('last_name ASC').all.map {|m| [m.full_name, m.id]}
  end

  def current?
    start_time < Time.now && end_time > Time.now
  end

  def set_primary_from_name
    tname = name.split(' ').join(' ').downcase.gsub(' ', '_')
    if mem = Member.where(:user_name => tname).first
      self.primary_id = mem.id
    end
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
#  id                      :integer         not null, primary key
#  org_id                  :integer         default(1)
#  year                    :integer
#  quarter                 :integer
#  week                    :integer
#  name                    :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  primary_id              :integer
#  backup_id               :integer
#  start                   :datetime
#  finish                  :datetime
#  reminder_notice_sent_at :datetime
#  alert_notice_sent_at    :datetime
#

