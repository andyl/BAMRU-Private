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

  def create_outbound_mail(dist, hash)
    new_label = gen_label
    hash[:label] = new_label
    hash[:distribution_id] = dist.id
    om = OutboundMail.create(hash)
    if om.distribution.message.rsvp
      om.distribution.rsvp = true
      om.distribution.save
    end
  end

  def send_mail(outbound_mail)
    puts "sending to #{outbound_mail.address}"
    mailing    = nil
    message    = outbound_mail.distribution.message
    address    = outbound_mail.email_address
    full_label = outbound_mail.full_label
    dist       = outboune_mail.distribution
    opts    = Notifier.set_optz(message, address, full_label, dist)
    mailing = Notifier.process_email_message(opts) if outbound_mail.email
    mailing = Notifier.process_sms_message(opts)   if outbound_mail.phone
    unless mailing.nil?
      mailing.deliver
      outbound_mail.sent_at = Time.now
      outbound_mail.save
    end
  end

  require 'carrier'

  desc "Send Email Distribution MESSAGE_ID=<integer>"
  task :send_distribution => 'environment' do
    Time.zone = "Pacific Time (US & Canada)"
    msg_id = ENV["MESSAGE_ID"]
    message = Message.find_by_id(msg_id)
    message.distributions.each do |dist|
      member = dist.member
      if dist.phone?
        member.phones.pagable.each do |phone|
          create_outbound_mail(dist, {:phone_id => phone.id, :address => phone.sms_email})
        end
      end
      if dist.email?
        member.emails.pagable.each do |email|
          create_outbound_mail(dist, {:email_id => email.id, :address => email.address})
        end
      end
    end
    send_list = CarrierQueueCollection.new
    message.distributions.each do |dist|
      dist.outbound_mails.each do |om|
        send_list.add(om)
      end
    end
    while send_obj = send_list.get
      send_mail(send_obj)
    end
  end

  def last_update_less_than_two_minutes_ago(file)
    puts "checking time..."
    (Time.now - File.new(file).mtime) < (60 * 2)
  end

  desc "Load inbound emails from our gmail account"
  task :import => 'environment' do
    file = "tmp/mail_sync_time.txt"
    if ENV['ONLY_ON'] && ENV['ONLY_ON'] != ENV['SYSNAME']
      puts "Exiting: command runs only on #{ENV["ONLY_ON"]}"
      puts '-' * 50
      exit
    end
    if File.exists?(file)
      if last_update_less_than_two_minutes_ago(file)
        puts "Exiting: last mail sync was less than two minutes ago."
        puts "-" * 50
        exit
      end
    end
    File.open(file, 'w') {|f| f.puts Time.now.strftime("%m-%d %H:%M:%S")}
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

