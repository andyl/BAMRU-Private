class MailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    message.to = STAGING_DELIVERY_ADDRESS
  end
end
