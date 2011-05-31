class Photo < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member
  acts_as_list :scope => :member_id

  has_attached_file :image, :styles => {:medium => "300x300", :thumb => "100x100"}

  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----


end
