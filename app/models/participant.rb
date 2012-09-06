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
#  id         :integer         not null, primary key
#  role       :string(255)
#  member_id  :integer
#  period_id  :integer
#  start      :datetime
#  finish     :datetime
#  created_at :datetime
#  updated_at :datetime
#

