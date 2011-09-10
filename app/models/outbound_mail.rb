class OutboundMail < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :distribution
  belongs_to :email
  belongs_to :phone
  has_many   :inbound_mails

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----

  scope :bounced, where(:bounced => true)
  scope :emails, where('email_id is not null')
  scope :phones, where('phone_id is not null')


  # ----- Local Methods-----


  # ----- Class Methods



end
