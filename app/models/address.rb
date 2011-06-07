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
  attr_accessible :typ, :position

  # ----- Associations -----
  belongs_to :member
  acts_as_list :scope => :member_id


  # ----- Callbacks -----


  # ----- Validations -----
  validates_presence_of :zip, :state
  validates_format_of   :zip, :with => /^[0-9]+$/

  validate :check_full_address_errors

  def check_full_address_errors
    if errors.include?(:zip) || errors.include?(:state)
      errors.add(:full_address, "has errors")
    end
  end

  # ----- Scopes -----


  # ----- Local Methods-----

  def blank_hash
    hsh = {}
    hsh[:address1] = ""
    hsh[:address2] = ""
    hsh[:city]     = ""
    hsh[:state]    = ""
    hsh[:zip]      = ""
    hsh
  end

  def capitalize_each(string)
    string.split(' ').map {|w| w.capitalize}.join(' ')
  end

  def parse_address(string)
    base = File.dirname(File.expand_path(__FILE__))
    require base + '/../../lib/address_parser'
    tmp = AddressParser.new.parse(string)
    tmp.keys.each {|key| tmp[key] = tmp[key].to_s}
    blank_hash.merge(tmp)
  end

  def full_address
    "#{address1.bl}#{address2.bl}#{city} #{state} #{zip}"
  end

  def full_address=(input)
    hash = parse_address(input)
    self.zip      = hash[:zip]
    self.address1 = capitalize_each(hash[:address1])
    self.address2 = capitalize_each(hash[:address2])
    self.city     = capitalize_each(hash[:city])
    self.state    = hash[:state].upcase
  end

  def output
    "#{address1.br}#{address2.br}#{city} #{state} #{zip} (#{typ})"
  end

end
