class Notifier < ActionMailer::Base
  default :from => "akleak@gmail.com"

  def test(member)
    @member = member
    mail(
            :to => member.emails.first.address,
            :subject => "Registered"
    )
  end
end
