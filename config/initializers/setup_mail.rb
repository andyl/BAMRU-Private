require File.expand_path('/../../lib/mail_interceptor', File.dirname(__FILE__))

ActionMailer::Base.smtp_settings = SMTP_SETTINGS

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
Mail.register_interceptor(MailInterceptor) unless Rails.env.production?