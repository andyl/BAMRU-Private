class AvailOp < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member


  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----
  scope :current, where("start < ?", Time.now).where("end > ?", Time.now)


  # ----- Local Methods-----


end
