class Participant < ActiveRecord::Base

  # ----- Associations -----
  belongs_to   :period
  belongs_to   :member

  # ----- Callbacks -----

  after_create :set_sign_in_times

  # ----- Scopes -----

  # see http://railscasts.com/episodes/215-advanced-queries-in-rails-3
  scope :registered, -> { joins(:member).merge(Member.registered) }

  # ----- API -----

  def as_json(options = {})
    {
        id:             self.id,
        ol:             self.ol,
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

  def sign_in_minutes
    return "TBD" unless self.signed_in_at && self.signed_out_at
    ((self.signed_out_at - self.signed_in_at) / 60).round
  end

  def set_sign_in_times
    event = self.period.event
    return unless event.typ == "meeting"
    self.update_attributes signed_in_at: event.start, signed_out_at: event.finish
  end

  def sort_key
    ols = ol ? 5000 : 0
    tys = -1 * self.member.typ_score
    score = ols + tys
    kscore = 10000 - score
    "#{kscore.to_s.rjust(5,'0')} #{self.member.last_name}"
  end
  
end


# == Schema Information
#
# Table name: participants
#
#  id             :integer         not null, primary key
#  ol             :boolean         default(FALSE)
#  member_id      :integer
#  period_id      :integer
#  comment        :string(255)
#  en_route_at    :datetime
#  return_home_at :datetime
#  signed_in_at   :datetime
#  signed_out_at  :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

