require 'time'
require 'date'

class InboundMail < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :outbound_mail

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----
  scope :bounced,   -> { where(:bounced => true) }
  scope :unmatched, -> { where('outbound_mail_id is NULL')}


  # ----- Local Methods-----

  def rsvp_answer_text
    return "" if rsvp_answer.blank?
    "(RSVP=<b>#{rsvp_answer}</b>)"
  end

  def email_changed?
    return false if outbound_mail.email.nil?
    outbound_mail.address != outbound_mail.email.address
  end

  def email_disabled?
    outbound_mail.email && outbound_mail.email.pagable == '0'
  end

  def phone_changed?
    return false if outbound_mail.phone.nil?
    outbound_mail.address != outbound_mail.phone.sms_email
  end

  def phone_disabled?
    outbound_mail.phone && outbound_mail.phone.pagable == '0'
  end

  def deleted?
    outbound_mail.phone.blank? && outbound_mail.email.blank?
  end

  def disabled?
    email_disabled? || phone_disabled?
  end

  def ignored?
    ignore_bounce?
  end

  def fixed?
    email_changed? || phone_changed? || deleted?  || disabled? || ignored?
  end

  def has_open_bounce?
    bounced? && ! ignore_bounce && ! fixed?
  end

  def has_fixed_bounce?
    bounced? && fixed?
  end

end

# == Schema Information
#
# Table name: inbound_mails
#
#  id               :integer         not null, primary key
#  outbound_mail_id :integer
#  from             :string(255)
#  to               :string(255)
#  uid              :string(255)
#  subject          :string(255)
#  label            :string(255)
#  body             :text
#  rsvp_answer      :string(255)
#  send_time        :datetime
#  bounced          :boolean         default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#  ignore_bounce    :boolean         default(FALSE)
#

