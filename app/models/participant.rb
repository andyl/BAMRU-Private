class Participant < ActiveRecord::Base

  # ----- Associations -----
  belongs_to   :period
  belongs_to   :member

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

