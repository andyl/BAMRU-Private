class User < ActiveRecord::Base

  # ----- Devise -----
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me


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

  # ----- Callbacks -----



  # ----- Validations -----
#  validates_presence_of :first_name, :last_name



  # ----- Scopes -----



  # ----- Local Methods-----



end
