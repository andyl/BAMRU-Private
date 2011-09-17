require 'time'
require 'date'

class InboundMail < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :outbound_mail

  # ----- Callbacks -----

  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----

  def rsvp_answer_text
    return "" if rsvp_answer.blank?
    "(RSVP=<b>#{rsvp_answer}</b>)"
  end

  # ----- Class Methods

  def self.create_from_mail(mail)
    opts = {}
    opts[:subject]   = mail.subject
    opts[:from]      = mail.from.join(' ')
    opts[:to]        = mail.to.join(' ')
    opts[:uid]       = mail.uid
    opts[:body]      = mail.body.to_s
    opts[:send_time] = mail.date.to_s
    puts mail.class
    puts mail.date.to_s
    puts '-' * 60
    opts[:rsvp_answer] = "Yes" if opts[:body].match(/\.[Yy][Ee][Ss]\./)
    opts[:rsvp_answer] = "No" if opts[:body].match(/\.[Nn][Oo]\./)
    full_reply = opts[:subject] + " " + opts[:body]
    opts[:bounced]  = true if opts[:from].match(/mailer-daemon/i)
    if match = full_reply.match(/\[[a-z\- ]*\_([0-9a-z][0-9a-z][0-9a-z][0-9a-z])\]/)
      opts[:label] = match[1]
      outbound = OutboundMail.where(:label => opts[:label]).first
      unless outbound.nil?
        opts[:outbound_mail_id] = outbound.id
        if opts[:bounced]
          outbound.distribution.bounced = true
          outbound.distribution.save
          outbound.bounced = true
          outbound.save
        else
          outbound.read = true ; outbound.save
          outbound.distribution.read = true
          outbound.distribution.rsvp_answer = opts[:rsvp_answer] unless opts[:rsvp_answer].nil?
          outbound.distribution.save
        end
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
#  body             :string(255)
#  send_time        :datetime
#  bounced          :boolean         default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#

