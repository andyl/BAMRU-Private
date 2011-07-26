class Role < ActiveRecord::Base

  # ----- Associations -----


  
  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----
  scope :bd, where(:typ => "Bd")
  scope :ol, where(:typ => "OL")



  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end


end
