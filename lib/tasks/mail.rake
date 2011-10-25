namespace :ops do

  desc "RAKE TEST COMMAND"
  task :raketest do
    puts "STARTING TEST COMMAND (PID: #{Process.pid})"
    STDOUT.flush
    sleep 10
    puts "ENDING TEST COMMAND (PID: #{Process.pid})"
    STDOUT.flush
  end

  namespace :email do

    # ----- Utilities for generating unique message labels -----

    def label4c
      rand((36**4)-1).to_s(36)
    end

    def gen_label
      new_label = label4c
      new_label = label4c until OutboundMail.where(:label => new_label).empty?
      puts "New Label is #{new_label}"
      new_label
    end

    # ----- Forgot Password Email -----

    desc "Send Password Reset Mail ADDRESS=<email_address> URL=<return_url>"
    task :password_reset => ['environment'] do
      puts "Sending forgot password mail to #{ENV["ADDRESS"]} at #{Time.now}"
      STDOUT.flush
      Time.zone = "Pacific Time (US & Canada)"
      mailing = Notifier.password_reset_email(ENV["ADDRESS"], ENV["URL"])
      mailing.deliver
    end

    # ----- Outbound Pager Messages -----

    def send_mail(outbound_mail)
      puts "sending to #{outbound_mail.address}"
      STDOUT.flush
      mailing    = nil
      message    = outbound_mail.distribution.message
      address    = outbound_mail.email_address
      full_label = outbound_mail.full_label
      dist       = outbound_mail.distribution
      opts    = Notifier.set_optz(message, address, full_label, dist)
      mailing = Notifier.process_email_message(opts) if outbound_mail.email
      mailing = Notifier.process_sms_message(opts)   if outbound_mail.phone
      unless mailing.nil?
        mailing.deliver
        id         = outbound_mail.id
        local_base = root_url
        local_url  = "#{local_base}api/mails/#{id}/sent_at_now.json"
        cmd = "curl -s -S -u #{SYSTEM_USER}:#{SYSTEM_PASS} #{local_url}"
        puts cmd.gsub(SYSTEM_PASS, "....")
        system cmd
      end
    end

    require 'carrier_queue'

    desc "Send Pending Mails"
    task :send_pending_mails => 'environment' do
      Time.zone = "Pacific Time (US & Canada)"
      include Rails.application.routes.url_helpers
      default_url_options[:host] = (Rails.env == "development") ? "ekel" : "bamru.net"
      default_url_options[:port] = "3000" if Rails.env == "development"
      send_list = CarrierQueueCollection.new
      mails = OutboundMail.pending.all
      mails.each { |om| send_list.add(om) }
      while send_obj = send_list.get
        send_mail(send_obj)
      end
      STDOUT.flush
    end

    # ----- Inbound Pager Messages -----

    def last_update_less_than_two_minutes_ago(file)
      puts "checking time..."
      (Time.now - File.new(file).mtime) < (60 * 2)
    end

    desc "Load inbound emails from our gmail account"
    task :import => 'environment' do
      file = "tmp/mail_sync_time.txt"
      if ENV['ONLY_ON'] && ENV['ONLY_ON'] != ENV['SYSNAME']
        puts "Exiting: command runs only on #{ENV["ONLY_ON"]}"
        exit
      end
      if File.exists?(file)
        if last_update_less_than_two_minutes_ago(file)
          puts "Exiting: last mail sync was less than two minutes ago."
          exit
        end
      end

            #include Rails.application.routes.url_helpers
            #default_url_options[:host] = (Rails.env == "development") ? "ekel" : "bamru.net"
            #default_url_options[:port] = "3000" if Rails.env == "development"

      File.open(file, 'w') {|f| f.puts Time.now.strftime("%m-%d %H:%M:%S")}
      Time.zone = "Pacific Time (US & Canada)"
      gm = Gmail.new(GMAIL_USER, GMAIL_PASS)
      gm.inbox.emails.each do |email|
        puts "Processing mail #{email.uid}"
        STDOUT.flush
        InboundMail.create_from_mail(email)

                #id         = outbound_mail.id
                #local_base = root_url
                #local_url  = "#{local_base}api/mails/#{id}/sent_at_now.json"
                #cmd = "curl -s -S -u #{SYSTEM_USER}:#{SYSTEM_PASS} #{local_url}"
                #puts cmd.gsub(SYSTEM_PASS, "....")
                #system cmd

        #system "curl a b c d e"
        email.archive!
      end
      gm.logout
      puts "Mail Sync Finished " + Time.now.to_s
      STDOUT.flush
    end

  end
end

