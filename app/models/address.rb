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

  validates_presence_of :zip, :state
  validates_format_of   :zip, :with => /^[0-9]+$/



  # ----- Scopes -----



  # ----- Local Methods-----

  def parse_address(string)
    base = File.dirname(File.expand_path(__FILE__))
    require base + '/../../lib/address_parser'
    tmp = AddressParser.new.parse(string)
    tmp.keys.each {|key| tmp[key] = tmp[key].to_s}
    tmp
  end

  def full_address
    "#{address1.bl}#{address2.bl}#{city} #{state} #{zip}"
  end

  def full_address=(input)
    update_attributes(parse_address(input))
  end

  def output
    "#{address1.br}#{address2.br}#{city} #{state} #{zip} (#{typ})"
  end

end
