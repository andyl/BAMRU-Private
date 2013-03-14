class OutboundMail < ActiveRecord::Base

  # ----- Attributes -----

  attr_accessible :distribution_id, :email_id, :phone_id, :address, :label, :read, :bounced


  # ----- Associations -----

  belongs_to :distribution
  belongs_to :email
  belongs_to :phone
  has_many   :inbound_mails, :dependent => :destroy

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----

  scope :bounced, -> { where(:bounced => true)         }
  scope :emails,  -> { where('email_id is not null')   }
  scope :phones,  -> { where('phone_id is not null')   }
  scope :pending, -> { where(:sent_at => nil)          }

  # ----- Local Methods-----
  def has_open_bounce?
    bounced_im = inbound_mails.bounced.all
    return false if bounced_im.blank?
    bounced_im.any? {|im| im.has_open_bounce?}
  end

  def has_fixed_bounce?
    bounced_im = inbound_mails.bounced.all
    return false if bounced_im.blank?
    bounced_im.any? {|im| im.has_fixed_bounce?}
  end

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

  def email_changed?
    return false if email.nil?
    address != email.address
  end

  def email_deleted?
    email_id && email.blank?
  end

  def email_disabled?
    return false if email.nil?
    email.pagable == '0'
  end

  def phone_changed?
    return false if phone.nil?
    address != phone.sms_email
  end

  def phone_deleted?
    phone_id && outbount_mail.phone.blank?
  end

  def phone_disabled?
    return false if phone.nil?
    phone.pagable == '0'
  end

  def changed?
    phone_changed? || email_changed?
  end

  def deleted?
    phone_deleted? || email_deleted?
  end

  def disabled?
    phone_disabled? || email_disabled?
  end

  def to_json
    as_json.to_json
  end

  # ----- Class Methods


end

# == Schema Information
#
# Table name: outbound_mails
#
#  id              :integer          not null, primary key
#  distribution_id :integer
#  email_id        :integer
#  phone_id        :integer
#  address         :string(255)
#  label           :string(255)
#  read            :boolean          default(FALSE)
#  bounced         :boolean          default(FALSE)
#  created_at      :datetime
#  updated_at      :datetime
#  sent_at         :datetime
#

