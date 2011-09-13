class Chat < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----


  # ----- Class Methods


end

# == Schema Information
#
# Table name: chats
#
#  id         :integer         not null, primary key
#  member_id  :integer
#  client     :string(255)
#  lat        :string(255)
#  lon        :string(255)
#  ip_address :string(255)
#  text       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

