class String
  def br
    self.blank? ? "" : self + "<br/>"
  end
  def bl
    self.blank? ? "" : self + "\n"
  end
end


class Address < ActiveRecord::Base
  
  # ----- Attributes -----
  attr_accessible :full_address
  attr_accessible :address1, :address2, :city, :state, :zip
  attr_accessible :typ

  # ----- Associations -----

  belongs_to :member


  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----

  def full_address
    "#{address1.bl}#{address2.bl}#{city} #{state} #{zip}"
  end

  def full_address=(input)
    "TBD"
  end

  def output
    "#{address1.br}#{address2.br}#{city} #{state} #{zip} (#{typ})"
  end

end
