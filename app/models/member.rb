class Member < ActiveRecord::Base

  # ----- Devise -----
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable #, :validatable

  # ----- Attributes -----

  # Setup accessible (or protected) attributes for your model
  attr_accessible :password, :password_confirmation, :remember_me
  attr_accessible :user_name, :first_name, :last_name, :full_name
  attr_accessible :typ, :v9, :ham, :base_role
  attr_accessible :phones_attributes, :addresses_attributes
  attr_accessible :roles_attributes, :emails_attributes, :certs_attributes
  attr_accessible :avail_ops_attributes, :avail_dos_attributes
  attr_accessible :emergency_contacts_attributes
  attr_accessible :other_infos_attributes
  attr_accessible :bd, :ol

  # ----- Associations -----
  has_many :addresses,   :order => 'position'
  has_many :phones,      :order => 'position'
  has_many :emails,      :order => 'position'
  has_many :photos,      :order => 'position'
  has_many :other_infos, :order => 'position'
  has_many :emergency_contacts, :order => 'position'
  has_many :roles
  has_many :certs
  has_many :avail_ops
  has_many :avail_dos
  has_many :messages
  has_many :distributions
  has_many :notices, :through => :distributions, :source => :message

  accepts_nested_attributes_for :addresses, :allow_destroy => true
  accepts_nested_attributes_for :phones,    :allow_destroy => true, :reject_if => lambda {|a| a[:number].blank? }
  accepts_nested_attributes_for :emails,    :allow_destroy => true, :reject_if => lambda {|a| a[:address].blank? }
  accepts_nested_attributes_for :roles,     :allow_destroy => true
  accepts_nested_attributes_for :certs,     :allow_destroy => true
  accepts_nested_attributes_for :avail_ops, :allow_destroy => true
  accepts_nested_attributes_for :avail_dos, :allow_destroy => true
  accepts_nested_attributes_for :emergency_contacts,    :allow_destroy => true
  accepts_nested_attributes_for :other_infos,           :allow_destroy => true

  # ----- Validations -----
  validates_associated    :addresses, :phones, :emails

  validates_presence_of   :first_name, :last_name, :user_name
  validates_format_of     :first_name, :with => /^[A-Za-z\- \.]+$/
  validates_format_of     :last_name,  :with => /^[A-Za-z\- \.]+$/
  validates_format_of     :user_name,  :with => /^[a-z_\.\-]+$/
  validates_uniqueness_of :user_name

  validate :check_full_name_errors

  def check_full_name_errors
    if errors.include?(:first_name) || errors.include?(:last_name)
      errors.add(:full_name, "has errors")
    end
  end

  # ----- Callbacks -----
  before_validation :set_username_and_name_fields
  before_validation :set_pwd

  # ----- Scopes -----
  scope :order_by_last_name, order("last_name ASC")
  scope :with_photos,        where("id     IN (SELECT member_id from photos)")
  scope :without_photos,     where("id NOT IN (SELECT member_id from photos)")

  # ----- Virtual Attributes (Accessors) -----

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name=(input)
    str = input.split(' ', 2)
    self.first_name = str.first.capitalize
    self.last_name  = str.last.capitalize
  end

  def bd
    roles.all.find {|r| r.typ.downcase == "bd"} ? true : false
  end

  def bd=(val)
    if val == "1" || val == true
      unless bd
        roles.create(:typ => "Bd")
      end
    end
    if val == "0" || val == false
      role = roles.bd.first
      role.destroy unless role.blank?
    end
  end

  def ol
    roles.all.find {|r| r.typ.downcase == "ol"} ? true : false
  end

  def ol=(val)
    if val == "1" || val == true
      unless ol
        roles.create(:typ => "OL")
      end
    end
    if val == "0" || val == false
      role = roles.ol.first
      role.destroy unless role.blank?
    end
  end

  # ----- Virtual Attributes (Readers) -----

  def short_name
    first_initial = first_name[0..0]
    "#{first_initial}. #{last_name}"
  end

  def full_roles
    arr = ([typ] + roles.map {|r| r.typ})
    arr.sort{|x,y| role_val(x) <=> role_val(y)}.join(' ')
  end

  def display_cert(type)
    cert = certs.where(:typ => type).first
    return "<td></td>" if cert.blank?
    cert.display
  end

  def cert_color_name
    "<span style='color: #{get_cert_color};'>#{full_name}</span>"
  end

  # ----- Instance Methods -----
  def get_cert_color
    current_medical_and_cpr? ? "black" : "red"
  end

  def current_medical?
    ! certs.medical.blank? && certs.medical.first.current?
  end

  def current_cpr?
    ! certs.cpr.blank? && certs.cpr.first.current?
  end

  def current_medical_and_cpr?
    current_medical? && current_cpr?
  end

  def new_username_from_names
    return "" if first_name.nil? || last_name.nil?
    fname = self.first_name.downcase.gsub(/[ \.]/,'_')
    lname = self.last_name.downcase.gsub(/[ \.]/,'_')
    "#{fname}.#{lname}"
  end

  def set_pwd
    self.password = "welcome" if self.password.blank?
  end

  def new_names_from_username
    return ["",""] if user_name.blank?
    user_name.split('.').map {|n| n.capitalize}
  end

  def cleanup_user_name
    self.user_name = self.user_name.downcase unless self.user_name.blank?
  end

  def set_username_and_name_fields
    cleanup_user_name
    self.user_name = new_username_from_names if self.user_name.blank?
    if self.first_name.blank? && self.last_name.blank?
      self.first_name, self.last_name = new_names_from_username
    end
  end

  def email_required?
    false
  end

  def all_related(item, message, separator = "<br/>")
    result = item.map {|a| a.output}.join(separator)
    result.blank? ? "" : "<b>#{message}:</b><br/>#{result}"
  end

  def all_assoc
    p = all_related(phones, "Phones")
    a = all_related(addresses, "Addresses")
    e = all_related(emails, "Emails")
    c = all_related(emergency_contacts, "Emergency Phone Contacts")
    o = all_related(other_infos, "Other Information")
    [p,e,a,c,o].find_all {|x| ! x.blank?}.join("</p>")
  end

  def role_val(role)
    case role
      when "Bd" : -500
      when "OL" : -250
      when "TM" : -100
      when "FM" : -50
      when "T"  : -25
      when "R"  : -10
      when "A"  : -5
      when "S"  : -1
      else 0
    end
  end

  def self.autoselect_member_names(suffix = "")
    order('last_name ASC').all.map do |m|
      "{label: '#{m.full_name}', url: '/members/#{m.id}#{suffix}'}"
    end.join(',')
  end

  # ----- For Error Reporting -----

  def scrubbed_errors
    scrubbed_err = errors.messages.clone
    scrubbed_err.delete(:full_name)
    scrubbed_err.delete(:addresses)
    scrubbed_err.delete(:phones)
    scrubbed_err.delete(:"address.full_address")
    scrubbed_err.delete(:"addresses.full_address")
    scrubbed_err
  end

  def full_messages(hash = scrubbed_errors)
    hash.map { |attribute, message|
      if attribute == :base
        message
      else
        attr_name = attribute.to_s.gsub('.', '_').humanize
        attr_name = self.class.human_attribute_name(attribute, :default => attr_name)

        message = message.join(', ') if message.class == Array

        I18n.t(:"errors.format", {
                :default   => "%{attribute}: %{message}",
                :attribute => attr_name,
                :message   => message
        })
        "#{attr_name}: #{message}"
      end
    }
  end


end


