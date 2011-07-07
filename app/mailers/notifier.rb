class Notifier < ActionMailer::Base
  default :from => "akleak@gmail.com"

  def test(member = "")
    @member = member
    mail(
            :to => member.emails.first.address,
            :subject => "Test @ #{Time.now}"
    )
  end

  def password_reset_email(address, url)
    # Time.zone = "Pacific Time (US & Canada)"
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
end
