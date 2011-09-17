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

  def rsvp_text_email(dist)
    return "" unless dist.message.rsvp
    <<-EOF.gsub(/^      /, "")
      RSVP: #{dist.message.rsvp.prompt}
       YES: #{dist.message.rsvp.yes_prompt} (#{root_url}rsvps/#{dist.id}?response=yes)
        NO: #{dist.message.rsvp.no_prompt} (#{root_url}rsvps/#{dist.id}?response=no)
    EOF
  end

  def roster_email_message(message, address, label, dist)
    Time.zone  = "Pacific Time (US & Canada)"
    @author    = message.author.full_name
    @mobile    = message.author.phones.mobile.first.try(:number) || "NA"
    @email     = message.author.emails.order('position ASC').first.try(:address) || "NA"
    @text      = message.text
    @rsvp_email_text = rsvp_text_email(dist)
    mail(
            :to          => address,
            :from        => "BAMRU.net <bamru.net@gmail.com>",
            :subject     => "BAMRU Page [#{label}]"
    )
  end

  def rsvp_text_phone(dist)
    return "" unless dist.message.rsvp
    "| RSVP #{dist.message.rsvp.prompt}"
  end

  def roster_phone_message(message, address, label, dist)
    Time.zone = "Pacific Time (US & Canada)"
    @author  = message.author.short_name
    @text    = message.text
    @rsvp_phone_text = rsvp_text_phone(dist)
    mail(
            :to          => address,
            :subject     => "BAMRU Page [#{label}]"
    )
  end

end
