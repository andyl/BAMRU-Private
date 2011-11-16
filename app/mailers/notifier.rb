class Notifier < ActionMailer::Base
  extend NotifierHelper

  def test(opts = {})
    address = opts[:author_email] ? 'test@what.com' : opts[:author_email]
    mail(
            :to => address,
            :from => 'bamru.net@gmail.com',
            :subject => "Test @ #{Time.now}"
    )
  end

  def password_reset_email(address, url)
    Time.zone = "Pacific Time (US & Canada)"
    @address = address
    @url     = url
    @member  = Email.find_by_address(address).member
    @member.reset_forgot_password_token
    @expire  = @member.forgot_password_expires_at.strftime("%H:%M")
    mail(
            :to => address,
            :from => 'bamru.net@gmail.com',
            :subject => "BAMRU.net Password Reset"
    )
  end

  def process_email_message(opts = {})
    Time.zone      = "Pacific Time (US & Canada)"
    @opts = Notifier.query_opts(opts)
    @short_label = @opts['label'].split('_').last
    mail(
            :to          => @opts['recipient_email'],
            :from        => "BAMRU (#{@opts['author_short_name']}) <bamru.net@gmail.com>",
            :subject     => "BAMRU Page [#{@opts['label']}]"
    )
  end

  def process_sms_message(opts = {})
    Time.zone = "Pacific Time (US & Canada)"
    @opts = Notifier.query_opts(opts)
    mail(
            :to          => @opts['recipient_email'],
            :from        => "BAMRU (#{@opts['author_short_name']}) <bamru.net@gmail.com>",
            :subject     => "BAMRU [#{@opts['label']}]"
    )
  end

end