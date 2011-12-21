require File.dirname(File.expand_path(__FILE__)) + '/../../lib/development_mail_interceptor'

SMTP_SETTINGS = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => GMAIL_USER,
  :password             => GMAIL_PASS,
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.smtp_settings = SMTP_SETTINGS

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?