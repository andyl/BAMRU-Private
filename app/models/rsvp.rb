class Rsvp < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :message



  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----


end

# == Schema Information
#
# Table name: rsvps
#
#  id         :integer          not null, primary key
#  message_id :integer
#  prompt     :string(255)
#  yes_prompt :string(255)
#  no_prompt  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

