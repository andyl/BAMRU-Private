class OutboundMail < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :distribution
  belongs_to :email
  belongs_to :phone
  has_many   :inbound_mails

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----


  # ----- Class Methods



end
