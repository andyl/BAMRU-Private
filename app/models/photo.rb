class Photo < ActiveRecord::Base

  # ----- Associations -----
  belongs_to   :member
  acts_as_list :scope => :member_id

  has_attached_file :image, :styles => {:medium => "300x300", :roster => "150x150", :thumb => "100x100", :icon => "30x30"}

  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end


end
