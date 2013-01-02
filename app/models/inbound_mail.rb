require 'time'
require 'date'

class InboundMail < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :outbound_mail

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----
  scope :bounced, -> { where(:bounced => true) }


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


  # ----- Class Methods -----

  def self.match_code(input)
    input.match(/\[[a-z\- ]*\_([0-9a-z][0-9a-z][0-9a-z][0-9a-z])\]/) ||
            input.match(/\.([0-9a-z][0-9a-z][0-9a-z][0-9a-z])/)
  end

  def self.create_from_mail(mail)
    opts = {}
    opts[:subject]   = mail.subject
    opts[:from]      = mail.from.join(' ')
    opts[:to]        = mail.to.join(' ')
    #opts[:uid]       = mail.try(:uid)
    opts[:body]      = mail.body.to_s.lstrip
    opts[:send_time] = mail.date.to_s
    create_from_opts(opts)
  end
    
  def self.create_from_opts(opts)
    valid_yes = %w(Yep Yea Y)
    valid_no  = %w(N Not Unavail Unavailable)
    opts[:bounced]  = true if opts[:from].match(/mailer-daemon/i)
    first_words = opts[:body].split(' ')[0..30].join(' ')
    match = first_words.match(/\b(yep|yea|yes|y|no|n|not|unavail|unavailable)\b/i)
    opts[:rsvp_answer] = match && match[0].capitalize
    opts[:rsvp_answer] = "Yes" if valid_yes.include? opts[:rsvp_answer]
    opts[:rsvp_answer] = "No"  if valid_no.include? opts[:rsvp_answer]
    outbound = nil
    if match = self.match_code("#{opts[:subject]} #{opts[:body]}")
      opts[:label] = match[1]
      outbound = OutboundMail.where(:label => opts[:label]).first
    end
    if outbound.nil?
      select_hash = {:address => opts[:from].downcase}
      outbound = OutboundMail.where(select_hash).order('created_at ASC').last
    end
    unless outbound.nil?
      opts[:outbound_mail_id] = outbound.id
      if opts[:bounced]
        outbound.distribution.bounced = true
        outbound.distribution.save
        outbound.bounced = true
        outbound.save
      else
        outbound.read = true ; outbound.save

        member = outbound.distribution.member
        answer = opts[:rsvp_answer]

        label = "Marked as read (reply to #{opts[:label]})"
        outbound.distribution.mark_as_read(member, member, label)
        outbound.distribution.set_rsvp(member, member, answer) unless answer.nil?
      end
    end
    create!(opts)
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

