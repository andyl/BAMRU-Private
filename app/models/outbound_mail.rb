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
  def full_label
    distribution.member.last_name.downcase + "_" + label
  end

  def email_address
    address
  end

  def email_org
    address.split('@').last.try(:downcase)
  end

  def typ
    return "phone" if phone
    return "email" if email
    return nil
  end


  # ----- Class Methods



end

# == Schema Information
#
# Table name: outbound_mails
#
#  id              :integer         not null, primary key
#  distribution_id :integer
#  email_id        :integer
#  phone_id        :integer
#  address         :string(255)
#  label           :string(255)
#  read            :boolean         default(FALSE)
#  bounced         :boolean         default(FALSE)
#  created_at      :datetime
#  updated_at      :datetime
#  datetime        :
#

