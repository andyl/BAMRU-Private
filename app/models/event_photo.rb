class EventPhoto < ActiveRecord::Base

  # ----- Associations -----
  belongs_to   :event
  belongs_to   :photo

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----


end


# == Schema Information
#
# Table name: event_photos
#
#  id         :integer         not null, primary key
#  event_id   :integer
#  photo_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

