class Member < ActiveRecord::Base

  # ----- Devise -----
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable #, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :password, :password_confirmation, :remember_me
  attr_accessible :login, :first_name, :last_name

  attr_accessor :login

  # ----- Associations -----
  has_many :addresses
  has_many :phones
  has_many :emails
  has_many :roles
  has_many :photos
  has_many :do_avails
  has_many :do_assignments
  has_many :messages
  has_many :distributions

  # ----- Validations -----
  validates_presence_of   :first_name, :last_name, :login
  validates_format_of     :first_name, :with => /^[A-Za-z \.]+$/
  validates_format_of     :last_name,  :with => /^[A-Za-z \.]+$/
  validates_format_of     :login,      :with => /^[a-z\.]+$/
  validates_uniqueness_of :login

  # ----- Callbacks -----
  before_validation :set_login_and_name_fields

  # ----- Scopes -----

  # ----- Local Methods-----
  def new_login_from_names
    return "" if first_name.blank? || last_name.blank?
    fname = self.first_name.downcase.gsub(/ \./,'_')
    lname = self.last_name.downcase.gsub(/ \./,'_')
    "#{fname}.#{lname}"
  end

  def new_names_from_login
    return ["",""] if login.blank?
    login.split('.').map {|n| n.capitalize}
  end

  def cleanup_login
    @login = @login.downcase unless @login.blank?
  end

  def set_login_and_name_fields
    cleanup_login
    self.login = new_login_from_names if login.blank?
    if first_name.blank? && last_name.blank?
      self.first_name, self.last_name = new_names_from_login
    end
  end

  def email_required?
    false
  end

end
