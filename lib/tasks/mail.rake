desc "Send Password Reset Email"

task :mail_msg do
  puts "Sending mail to #{ENV["ADDRESS"]} at #{Time.now}"
end

task :send_password_reset_mail => [:mail_msg, :environment] do
  # Time.zone = "Pacific Time (US & Canada)"
  mailing = Notifier.password_reset_email(ENV["ADDRESS"], ENV["URL"])
  mailing.deliver
end
