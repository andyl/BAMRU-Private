class Period < ActiveRecord::Base

  # ----- Associations -----

  belongs_to   :event
  has_many     :participants, :dependent => :destroy
  has_many     :period_pages
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
#  rsvp_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

