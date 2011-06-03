class Role < ActiveRecord::Base

  # ----- Associations -----


  
  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----
  scope :bd, where(:typ => "Bd")
  scope :ol, where(:typ => "OL")



  # ----- Local Methods-----


end
