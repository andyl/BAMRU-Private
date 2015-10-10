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
  scope :last_wk, -> { where('start < ?', Time.now - 1.week).where('finish > ?', Time.now - 1.week) }
  scope :current, -> { where('start < ?', Time.now).where('finish > ?', Time.now)                   }
  scope :this_wk, -> { where('start < ?', Time.now).where('finish > ?', Time.now)                   }
  scope :next_wk, -> { where('start < ?', Time.now + 1.week).where('finish > ?', Time.now + 1.week) }
  scope :pending, -> { where('start < ?', Time.now + 1.week).where('finish > ?', Time.now + 1.week) }
  scope :has_backup,  -> { where("backup_id <> NULL")                         }
  scope :non_current, -> { where('start > ? OR finish < ?', x = Time.now, x)  }

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

  def unavail_members
    all_members = Member.order('last_name ASC').all.map {|mem| mem.full_name}
    all_members - avail_members
  end

  def avail_members_with_unavail
    avails  = avail_members
    memlist = Member.order('last_name ASC').all.map {|m| [m.full_name, m.id]}
    memlist.map do |mem|
      if avails.include? mem.first
        mem
      else
        [mem[0].downcase + " (unavail)", mem[1]]
      end
    end.sort_by {|x| x[0].split[1]}
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
# Table name: do_assignments
#
#  id                      :integer          not null, primary key
#  org_id                  :integer          default(1)
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

