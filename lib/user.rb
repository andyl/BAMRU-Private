class User < ActiveRecord::Base

  # ----- Associations -----

  has_many :addresses, :phones, :emails, :roles, :photos
  has_many :do_avails, :do_assignments
  has_many :messages, :distributions

  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----


end
