class Participant < ActiveRecord::Base

  # ----- Associations -----
  belongs_to   :period
  belongs_to   :member

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----


end


# == Schema Information
#
# Table name: participants
#
#  id             :integer         not null, primary key
#  role           :string(255)
#  member_id      :integer
#  period_id      :integer
#  en_route_at    :datetime
#  return_home_at :datetime
#  signed_in_at   :datetime
#  signed_out_at  :datetime
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

