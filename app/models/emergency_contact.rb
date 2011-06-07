class EmergencyContact < ActiveRecord::Base

  attr_accessible :position, :name, :number

  # ----- Associations -----

  belongs_to :member
  acts_as_list :scope => :member_id


  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----

end
