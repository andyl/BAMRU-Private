class Period < ActiveRecord::Base

  # ----- Associations -----

  belongs_to   :event
  has_many     :participants, :dependent => :destroy
  acts_as_list :scope => :position


  # ----- Callbacks -----


  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----


end


# == Schema Information
#
# Table name: periods
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  event_id   :integer
#  position   :integer
#  start      :datetime
#  finish     :datetime
#  created_at :datetime
#  updated_at :datetime
#

