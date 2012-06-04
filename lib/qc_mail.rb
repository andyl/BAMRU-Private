class QcMail

  def self.pending_count
    OutboundMail.pending.count
  end

  def render_email_message(opts, format)
    case format
      when 'page'              then Notifier.page_email(opts)
      when 'password_reset'    then Notifier.password_reset_email(opts)
      when 'do_shift_pending'  then Notifier.do_shift_pending_email(opts)
      when 'do_shift_starting' then Notifier.do_shift_starting_email(opts)
      when 'cert_notice'       then Notifier.cert_notice_email(opts)
      else nil
    end
  end

  def render_phone_message(opts, format)
    case format
      when 'page'              then Notifier.page_phone(opts)
      when 'do_shift_starting' then Notifier.do_shift_starting_phone(opts)
      else nil
    end
  end

  def self.render_mail(outbound_mail)
    puts "rendering message for #{outbound_mail.address}"
    STDOUT.flush
    yaml_file = "/tmp/render_msg/#{outbound_mail.id}_#{outbound_mail.label}"
    return if File.exists?(yaml_file)
    mailing    = nil
    message    = outbound_mail.distribution.message
    address    = outbound_mail.email_address
    full_label = outbound_mail.full_label
    dist       = outbound_mail.distribution
    format     = message.format
    opts       = Notifier.set_optz(message, address, full_label, dist)
    mailing    = render_email_message(opts, format) if outbound_mail.email
    mailing    = render_phone_message(opts, format) if outbound_mail.phone
    unless mailing.nil?
      File.open(yaml_file, 'w') {|f| f.puts mailing.to_yaml}
    end
    yaml_file
  end

  def self.send_mail(yaml_file)
    require 'yaml'
    Time.zone = "Pacific Time (US & Canada)"
    tdate = Time.now.strftime("%y%m%d_%H%M%S")
      mail_attributes = YAML.load_file(yaml_file)
      mail = ActionMailer::Base.mail(mail_attributes)
      mail.subject = mail_attributes["Subject"]
      outbound_mail_id = yaml_file.split('/').last.split('_').first
      puts "sending message #{outbound_mail_id} (#{mail.to.first})"
      smtp_settings = [:smtp, SMTP_SETTINGS]
      mail.delivery_method(*smtp_settings) if Rails.env.production?
      mail.deliver
  end

  def self.send_pending
    OutboundMail.pending.each do |outbound_mail|
      yaml_file = render_mail(outbound_mail)
      result = send_mail(yaml_file)
      if result == 'success'
        outbound_mail.send_at = Time.now
        outbound_mail.save
      end
      sleep 0.25
    end
  end

end