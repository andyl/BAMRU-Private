class Participant < ActiveRecord::Base

  # ----- Attributes -----
  attr_accessible :ol, :ahc, :member_id, :period_id, :comment, :en_route_at, :return_home_at, :signed_in_at, :signed_out_at

  # ----- Associations -----
  belongs_to   :period
  belongs_to   :member

  # ----- Callbacks -----

  after_create :set_sign_in_times

  # ----- Scopes -----

  # see http://railscasts.com/episodes/215-advanced-queries-in-rails-3
  # aka 'non-guests'...
  scope :registered, -> { joins(:member).merge(Member.registered) }

  # for transit status...
  scope :has_not_left, -> { where('en_route_at is NULL')             }
  scope :has_left,     -> { where('en_route_at is not NULL')         }
  scope :is_en_route,  -> { has_left.where('return_home_at is NULL') }
  scope :has_returned, -> { where('return_home_at is not NULL')      }

  def self.by_mem_id(id)
    where(member_id: id)
  end

  # returns an array of member_id's
  # e.g. Period.find(342).participants.mem_ids
  # e.g. Period.find(342).participants.has_returned.mem_ids
  def self.mem_ids
    pluck(:member_id)
  end

  # ----- API -----

  def as_json(options = {})
    {
        id:             self.id,
        ol:             self.ol,
        ahc:            self.ahc,
        period_id:      self.period_id,
        member_id:      self.member_id,
        en_route_at:    self.en_route_at.try(:strftime, "%Y-%m-%d %H:%M"),
        return_home_at: self.return_home_at.try(:strftime, "%Y-%m-%d %H:%M"),
        signed_in_at:   self.signed_in_at.try(:strftime, "%Y-%m-%d %H:%M"),
        signed_out_at:  self.signed_out_at.try(:strftime, "%Y-%m-%d %H:%M"),
        updated_at:     self.updated_at.try(:strftime, "%Y-%m-%d %H:%M"),
    }
  end

  # ----- Instance Methods -----

  def transit_minutes
    return 0 unless self.en_route_at && self.return_home_at
    ((self.en_route_at - self.return_home_at) / 60).round.abs
  end

  def signin_minutes
    return 0 unless self.signed_in_at && self.signed_out_at
    ((self.signed_out_at - self.signed_in_at) / 60).round.abs
  end

  def report_minutes
    [transit_minutes, signin_minutes].max
  end

  def total_minutes
    rm = report_minutes
    rm == 0 ? "TBD" : rm
  end

  def start_at
    if transit_minutes.abs > signin_minutes.abs
      self.en_route_at
    else
      self.signed_in_at
    end
  end

  def finish_at
    if transit_minutes.abs > signin_minutes.abs
      self.return_home_at
    else
      self.signed_out_at
    end

  end

  def total_hours
    tm = total_minutes
    return "TBD" if tm == "TBD"
    return "TBD" if tm.nil?
    (tm.to_f / 60).round(1)
  end

  def set_sign_in_times
    event = self.period.try(:event)
    return unless event.try(:typ) == "meeting"
    self.update_attributes signed_in_at: event.start, signed_out_at: event.finish
  end

  def sort_key
    ahs = ahc ? 6000 : 0
    ols = ol ? 5000 : 0
    tys = -1 * self.member.typ_score
    score = ahs + ols + tys
    kscore = 10000 - score
    "#{kscore.to_s.rjust(5,'0')} #{self.member.last_name}"
  end
  
end

# == Schema Information
#
# Table name: participants
#
#  id             :integer          not null, primary key
#  ol             :boolean          default(FALSE)
#  member_id      :integer
#  period_id      :integer
#  comment        :string(255)
#  en_route_at    :datetime
#  return_home_at :datetime
#  signed_in_at   :datetime
#  signed_out_at  :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

