desc "Send Password Reset Email"
task :send_password_reset_mail => :environment do
  mailing = Notifier.password_reset_email(ENV["ADDRESS"])
  mailing.deliver
end