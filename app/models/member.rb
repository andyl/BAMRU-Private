class Member < ActiveRecord::Base

  # ----- Devise -----
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable #, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :password, :password_confirmation, :remember_me
  attr_accessible :user_name, :first_name, :last_name
  attr_accessible :typ, :v9, :ham, :base_role
  attr_accessible :phones_attributes, :addresses_attributes
  attr_accessible :roles_attributes, :emails_attributes

  # ----- Associations -----
  has_many :addresses
  has_many :phones
  has_many :emails
  has_many :roles
  has_many :certs
  has_many :photos
  has_many :oots
  has_many :pdo_quarters
  has_many :messages
  has_many :distributions

  accepts_nested_attributes_for :addresses, :allow_destroy => true
  accepts_nested_attributes_for :phones,    :allow_destroy => true
  accepts_nested_attributes_for :emails,    :allow_destroy => true
  accepts_nested_attributes_for :roles,     :allow_destroy => true

  # ----- Validations -----
  validates_presence_of   :first_name, :last_name, :user_name
  validates_format_of     :first_name, :with => /^[A-Za-z\- \.]+$/
  validates_format_of     :last_name,  :with => /^[A-Za-z\- \.]+$/
  validates_format_of     :user_name,      :with => /^[a-z_\.\-]+$/
  validates_uniqueness_of :user_name

  # ----- Callbacks -----
  before_validation :set_username_and_name_fields
  before_validation :set_pwd

  # ----- Scopes -----

  # ----- Local Methods-----
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
    p = all_related(phones, "Phone")
    a = all_related(addresses, "Address")
    e = all_related(emails, "Email")
    [p,a,e].find_all {|x| ! x.blank?}.join("</p>")
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def short_name
    first_initial = first_name[0..0]
    "#{first_initial}. #{last_name}"
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

  def full_roles
    arr = ([typ] + roles.map {|r| r.typ})
    arr.sort{|x,y| role_val(x) <=> role_val(y)}.join(' ')
  end
end
