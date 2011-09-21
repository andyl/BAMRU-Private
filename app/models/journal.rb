class Journal < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member
  belongs_to :distribution


  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----


end



# == Schema Information
#
# Table name: journals
#
#  id              :integer         not null, primary key
#  member_id       :integer
#  distribution_id :integer
#  action          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

