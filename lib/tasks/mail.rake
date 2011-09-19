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

  def send_mail(message, dist, hash, type)
    new_label = gen_label
    hash[:label] = new_label
    hash[:distribution_id] = dist.id
    om = OutboundMail.create(hash)
    if om.distribution.message.rsvp
      om.distribution.rsvp = true
      om.distribution.save
    end
    mailing = nil
    opts = Notifier.set_optz(message, hash[:address], om.full_label, dist)
    mailing = Notifier.process_email_message(opts) if type == "email"
    mailing = Notifier.process_sms_message(opts) if type == "phone"
    mailing.deliver unless mailing.nil?
    sleep 0.25
  end

  desc "Send Email Distribution MESSAGE_ID=<integer>"
  task :send_distribution => 'environment' do
    Time.zone = "Pacific Time (US & Canada)"
    msg_id = ENV["MESSAGE_ID"]
    message = Message.find_by_id(msg_id)
    message.distributions.each do |dist|
      member = dist.member
      if dist.phone?
        member.phones.pagable.each do |phone|
          send_mail(message, dist, {:phone_id => phone.id, :address => phone.sms_email}, "phone")
        end
      end
      if dist.email?
        member.emails.pagable.each do |email|
          send_mail(message, dist, {:email_id => email.id, :address => email.address}, "email")
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

