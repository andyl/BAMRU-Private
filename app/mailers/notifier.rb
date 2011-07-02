class Notifier < ActionMailer::Base
  default :from => "akleak@gmail.com"

  def test(member = "")
    @member = member
    mail(
            :to => member.emails.first.address,
            :subject => "Test @ #{Time.now}"
    )
  end

  def password_reset_email(address)
    @address = address
    @member  = Email.find_by_address(address).member
    mail(
            :to => address,
            :subject => "BAMRU.net Password Reset"
    )
  end
end
