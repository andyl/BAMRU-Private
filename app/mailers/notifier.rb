class Notifier < ActionMailer::Base
  default :from => "bamru.net@gmail.com"

  def test(member = "")
    @member = member
    mail(
            :to => member.emails.first.address,
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
            :subject => "BAMRU.net Password Reset"
    )
  end

  def roster_email_message(message, address, label)
    Time.zone = "Pacific Time (US & Canada)"
    @author  = message.author.full_name
    @mobile  = message.author.phones.mobile.first.try(:number) || "NA"
    @email   = message.author.emails.first.try(:address) || "NA"
    @text    = message.text
    mail(
            :to          => address,
            :from        => "BAMRU.net <bamru.net@gmail.com>",
            :subject     => "BAMRU Page [#{label}]"
    )
  end

  def roster_phone_message(message, address, label)
    Time.zone = "Pacific Time (US & Canada)"
    @author  = message.author.short_name
    @text    = message.text
    mail(
            :to          => address,
            :subject     => "BAMRU Page [#{label}]"
    )
  end

end
