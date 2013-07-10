require 'nexmo'
require 'nexmo_number_pool'

class QcMail

  def self.pending_count
    OutboundMail.pending.count
  end

  def self.render_email_message(opts, format)
    case format
      when 'page'              then Notifier.page_email(opts)
      when 'password_reset'    then Notifier.password_reset_email(opts)
      when 'do_shift_pending'  then Notifier.do_shift_pending_email(opts)
      when 'do_shift_starting' then Notifier.do_shift_starting_email(opts)
      when 'cert_notice'       then Notifier.cert_notice_email(opts)
      else nil
    end
  end

  def self.render_phone_message(opts, format)
    case format
      when 'page'              then Notifier.page_phone(opts)
      when 'do_shift_starting' then Notifier.do_shift_starting_phone(opts)
      else nil
    end
  end

  def self.render_mail(outbound_mail)
    Time.zone = "Pacific Time (US & Canada)"
    mailing    = nil
    message    = outbound_mail.distribution.message
    address    = outbound_mail.email_address
    full_label = outbound_mail.full_label
    dist       = outbound_mail.distribution
    format     = message.format
    opts       = Notifier.set_optz(message, address, full_label, dist)
    mailing    = render_email_message(opts, format) if outbound_mail.email
    mailing    = render_phone_message(opts, format) if outbound_mail.phone
    puts "sending message #{outbound_mail.id} (#{mailing.to.first})"
    smtp_settings = [:smtp, SMTP_SETTINGS]
    mailing.delivery_method(*smtp_settings) unless Rails.env.development?
    case Rails.env
      when "development" then mailing.deliver
      when "staging"     then mailing.deliver if valid_staging_address?(mail.to)
      when "production"  then mailing.deliver
    end
    outbound_mail.update_attributes(:sent_at => Time.now)
  end

  def self.sms_text(outbound_mail)
    mesg = outbound_mail.distribution.message
    auth = mesg.author.last_name
    rsvp = mesg.rsvp.nil? ? "" : " RSVP: #{mesg.rsvp.prompt}"
    "[BAMRU] #{mesg.text} (from #{auth})#{rsvp}"
  end

  def self.render_sms(outbound_mail)
    phone_id    = outbound_mail.phone_id
    recent_obj  = OutboundMail.where(phone_id: phone_id).recent.try(:to_a).try(:first)
    recent_num  = recent_obj.try(:sms_service_number)
    service_num = NexmoNumberPool.next(recent_num)
    member_num  = outbound_mail.phone.sanitized_number

    client = Nexmo::Client.new(NEXMO_SMS_KEY, NEXMO_SMS_SECRET)

    params = {
        to:   member_num,
        from: service_num,
        text: sms_text(outbound_mail)
    }

    _response = client.send_message(params)

    outbound_mail.update_attributes(sms_member_number: member_num, sms_service_number: service_num, sent_at: Time.now)

  end

  def self.send_pending
    start = Time.now
    ActiveSupport::Notifications.instrument("page.send", {:text => "start #{Time.now.strftime("%H:%M:%S")}"})
    count = pending_count
    OutboundMail.pending.each do |outbound_mail|
      render_mail(outbound_mail) if outbound_mail.email
      render_sms(outbound_mail)  if outbound_mail.phone
      label = "#{outbound_mail.address}-#{outbound_mail.label}"
      ActiveSupport::Notifications.instrument("page.send", {:text => label})
    end
    duration = (Time.now - start).round
    message  = "finish #{Time.now.strftime('%H:%M:%S')} (#{duration} sec)"
    ActiveSupport::Notifications.instrument("page.send", {:text => message })
    import_mail_in_background if count > 0
  end

  private

  def self.import_mail_in_background
    if Rails.env.production? || Rails.env.staging?
      timestamp = Time.now.strftime("%y%m%d-%H%M%S")
      system "mkdir -p log/loadmail"
      system "nohup script/loadmail > log/loadmail/#{timestamp}.log &"
    end
  end

  def self.valid_staging_address?(address)
    STAGING_VALID_EMAILS.gsub("'","").split(' ').include? address.first
  end


end
