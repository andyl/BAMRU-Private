class Photo < ActiveRecord::Base

  has_attached_file :image, :styles => {:medium => "300x300", :thumb => "100x100"}

  # ----- Associations -----

  belongs_to :user


  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----


end
