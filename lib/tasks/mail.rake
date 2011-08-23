namespace :email do

  task :mail_msg do
    puts "Sending mail to #{ENV["ADDRESS"]} at #{Time.now}"
  end

  desc "Send Password Reset Mail ADDRESS=<email_address> URL=<return_url>"
  task :password_reset => [:mail_msg, 'environment'] do
    Time.zone = "Pacific Time (US & Canada)"
    mailing = Notifier.password_reset_email(ENV["ADDRESS"], ENV["URL"])
    mailing.deliver
  end

  "Send Email Distribution MESSAGE_ID=<integer>"
  task :send_distribution => 'environment' do
    Time.zone = "Pacific Time (US & Canada)"
    msg_id = ENV["MESSAGE_ID"]
    message = Message.find_by_id(msg_id)
    message.recipients.each do |member|
      member.emails.pagable.each do |email|
        mailing = Notifier.roster_email(message, email.address)
        mailing.deliver
        sleep 0.25
      end
    end

  end

end

