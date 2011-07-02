desc "Send Password Reset Email"
task :send_password_reset_mail => :environment do
  Time.zone = "Pacific Time (US & Canada)"
  mailing = Notifier.password_reset_email(ENV["ADDRESS"], ENV["URL"])
  mailing.deliver
end