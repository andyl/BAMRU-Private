class EventFile < ActiveRecord::Base

  # ----- Associations -----
  belongs_to   :event
  belongs_to   :file

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----


end


# == Schema Information
#
# Table name: event_files
#
#  id         :integer         not null, primary key
#  event_id   :integer
#  file_id    :integer
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

