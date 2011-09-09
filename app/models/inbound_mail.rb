class InboundMail < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :outbound_mail

  # ----- Callbacks -----

  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----

  # ----- Class Methods

  def self.create_from_mail(mail)
    opts = {}
    opts[:subject] = mail.subject
    opts[:from]    = mail.from.join(' ')
    opts[:to]      = mail.to.join(' ')
    opts[:uid]     = mail.uid
    opts[:body]    = mail.body.to_s
    full_reply = opts[:subject] + " " + opts[:body]
    opts[:bounced]  = true if opts[:from].match(/mailer-daemon/i)
    if match = full_reply.match(/\[([a-z\- ]*\/[0-9a-z][0-9a-z][0-9a-z][0-9a-z])\]/)
      opts[:label] = match[1]
      outbound = OutboundMail.where(:label => opts[:label]).first
      unless outbound.nil?
        opts[:outbound_mail_id] = outbound.id
        if opts[:bounced]
          outbound.distribution.bounced = true
          outbound.distribution.save
        else
          outbound.read = true ; outbound.save
          outbound.distribution.read = true ; outbound.distribution.save
        end
      end
    end
    create!(opts)
  end



end
