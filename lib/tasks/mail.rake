require 'carrier_queue'
require 'rake_util'

include RakeUtil

# ----- Utilities for Rake Tasks -----

def check_host_and_run_frequency
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
  File.open(file, 'w') { |f| f.puts Time.now.strftime("%m-%d %H:%M:%S") }
end

# ----- Methods for Importing Mail -----

def last_update_less_than_two_minutes_ago(file)
  (Time.now - File.new(file).mtime) < (60 * 2)
end

def get_all_emails_from_gmail
  Time.zone = "Pacific Time (US & Canada)"
  gm = Gmail.new(GMAIL_USER, GMAIL_PASS)
  gm.inbox.emails.each do |email|
    puts "Caching mail #{email.uid}"
    STDOUT.flush
    write_email_to_disk(email)
    email.archive!
  end
  gm.logout
end

def mail_dir
  dir = Rails.root.to_s + "/tmp/inbound_mails"
  system "mkdir -p #{dir}"
  dir
end

def write_email_to_disk(mail)
  mail_file = "#{mail_dir}/#{Time.now.strftime("inbound_%y%m%d_%H%M%S")}.yaml"
  opts = {}
  opts[:subject]   = mail.subject
  opts[:from]      = mail.from.join(' ')
  opts[:to]        = mail.to.join(' ')
  opts[:uid]       = mail.try(:uid)
  opts[:body]      = mail.body.to_s.lstrip
  opts[:send_time] = mail.date.to_s
  File.open(mail_file, 'w') {|f| f.puts opts.to_yaml }
end

def load_all_emails_into_database
  cmd = curl_get("api/mails/load_inbound")
  puts "Loading emails into database..."
  # puts cmd.gsub(SYSTEM_PASS, "....")
  system cmd
end

# ----- Method for sending mail -----

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
    id          = outbound_mail.id
    invoke_url  = "api/mails/#{id}/sent_at_now.json"
    cmd = curl_get(invoke_url)
    puts cmd.gsub(SYSTEM_PASS, "....")
    system cmd
  end
end

# ----- Rake Tasks -----

namespace :ops do
  namespace :email do

    # ----- Forgot Password Email -----

    desc "Send Password Reset Mail ADDRESS=<email_address> URL=<return_url>"
    task :password_reset => 'environment' do
      puts "Sending forgot password mail to #{ENV["ADDRESS"]} at #{Time.now}"
      STDOUT.flush
      Time.zone = "Pacific Time (US & Canada)"
      mailing = Notifier.password_reset_email(ENV["ADDRESS"], ENV["URL"])
      mailing.deliver
    end

    # ----- Outbound Pager Messages -----

    desc "Send Pending Mails"
    task :send_pending_mails => 'environment' do
      Time.zone = "Pacific Time (US & Canada)"
      send_list = CarrierQueueCollection.new
      mails = OutboundMail.pending.all
      mails.each { |om| send_list.add(om) }
      while send_obj = send_list.get
        send_mail(send_obj)
      end
      STDOUT.flush
    end

    # ----- Inbound Pager Messages -----

    desc "Load inbound emails from our gmail account"
    task :import => 'environment' do
      check_host_and_run_frequency
      get_all_emails_from_gmail
      load_all_emails_into_database
    end

    namespace :generate do

      # ----- DO Mails -----

      desc "DO Reminder Mail"
      task :do_reminder => 'environment' do
        member = DoAssignment.next_wk.first.primary
        puts "Sending DO Assignment Reminder to #{member.full_name}"
        STDOUT.flush
        Time.zone = "Pacific Time (US & Canada)"
        mailing = Notifier.do_reminder_email(member)
        mailing.deliver
      end

      desc "DO Alert Mail"
      task :do_alert => 'environment' do

        puts "DO Alert TBD"
      end

      # ----- Cert Reminder Mails -----

      desc "Cert Reminders Mail"
      task :cert_reminders => 'environment' do
        puts "CERT REMINDER TBD"
      end

    end
  end
end
