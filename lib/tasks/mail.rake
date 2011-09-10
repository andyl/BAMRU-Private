namespace :email do

  def label4c
    rand((36**4)-1).to_s(36)
  end

  def gen_label
    new_label = label4c
    new_label = label4c until OutboundMail.where(:label => new_label).empty?
    puts "New Label is #{new_label}"
    new_label
  end

  task :mail_msg do
    puts "Sending mail to #{ENV["ADDRESS"]} at #{Time.now}"
  end

  desc "Send Password Reset Mail ADDRESS=<email_address> URL=<return_url>"
  task :password_reset => [:mail_msg, 'environment'] do
    Time.zone = "Pacific Time (US & Canada)"
    mailing = Notifier.password_reset_email(ENV["ADDRESS"], ENV["URL"])
    mailing.deliver
  end

  desc "Send Email Distribution MESSAGE_ID=<integer>"
  task :send_distribution => 'environment' do
    Time.zone = "Pacific Time (US & Canada)"
    msg_id = ENV["MESSAGE_ID"]
    message = Message.find_by_id(msg_id)
    message.distributions.each do |dist|
      member = dist.member
      lname  = member.last_name.downcase
      if dist.phone?
        member.phones.pagable.each do |phone|
          new_label = "#{lname}/#{gen_label}"
          OutboundMail.create(:phone_id => phone.id, :address => phone.sms_email, :distribution_id => dist.id, :label => new_label)
          mailing = Notifier.roster_phone_message(message, phone.sms_email, new_label)
          mailing.deliver
          sleep 0.25
        end
      end
      if dist.email?
        member.emails.pagable.each do |email|
          new_label = "#{lname}/#{gen_label}"
          OutboundMail.create(:email_id => email.id, :address => email.address, :distribution_id => dist.id, :label => new_label)
          puts "aut: #{message.author.full_name} / msg: #{message.text} / adr: #{email.address} / lbl: #{new_label}"
          mailing = Notifier.roster_email_message(message, email.address, new_label)
          mailing.deliver
          sleep 0.25
        end
      end
    end
  end

  def last_update_less_than_two_minutes_ago(file)
    puts "checking time..."
    (Time.now - File.new(file).mtime) < (60 * 2)
  end

  desc "Load inbound emails from our gmail account"
  task :import => 'environment' do
    file = "tmp/mail_sync_time.txt"
    if File.exists?(file)
      if last_update_less_than_two_minutes_ago(file)
        puts "Exiting: last mail sync was less than two minutes ago."
        puts "-" * 50
        exit
      end
    end
    File.open(file, 'w') {|f| f.puts Time.now.strftime("%y-%m-%d %H:%M:%S")}
    Time.zone = "Pacific Time (US & Canada)"
    gm = Gmail.new(GMAIL_USER, GMAIL_PASS)
    gm.inbox.emails.each do |email|
      puts "Processing mail #{email.uid}"
      InboundMail.create_from_mail(email)
      email.archive!
    end
    gm.logout
    puts "Mail Sync Finished " + Time.now.to_s
    puts "-" * 50
  end

end

