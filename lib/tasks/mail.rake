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
  cmd = curl_get("api/rake/messages/load_inbound")
  puts "Loading emails into database..."
  system cmd
end

# ----- Method for sending mail -----

def render_email_message(opts, format)
  case format
    when 'page'              : Notifier.page_email(opts)
    when 'password_reset'    : Notifier.password_reset_email(opts)
    when 'do_shift_pending'  : Notifier.do_shift_pending_email(opts)
    when 'do_shift_starting' : Notifier.do_shift_starting_email(opts)
    when 'cert_notice'       : Notifier.cert_notice_email(opts)
    else nil
  end
end

def render_phone_message(opts, format)
  case format
    when 'page'              : Notifier.page_phone(opts)
    when 'do_shift_starting' : Notifier.do_shift_starting_phone(opts)
    else nil
  end
end

def render_mail(outbound_mail)
  puts "rendering message for #{outbound_mail.address}"
  STDOUT.flush
  yaml_file = "/tmp/render_msg/#{outbound_mail.id}_#{outbound_mail.label}"
  return if File.exists?(yaml_file)
  mailing    = nil
  message    = outbound_mail.distribution.message
  address    = outbound_mail.email_address
  full_label = outbound_mail.full_label
  dist       = outbound_mail.distribution
  format     = message.format
  opts       = Notifier.set_optz(message, address, full_label, dist)
  mailing    = render_email_message(opts, format) if outbound_mail.email
  mailing    = render_phone_message(opts, format) if outbound_mail.phone
  unless mailing.nil?
    File.open(yaml_file, 'w') {|f| f.puts mailing.to_yaml}
    invoke_url = "api/rake/messages/render?address=#{outbound_mail.address}"
    cmd        = curl_get(invoke_url)
    system cmd
  end
end

def send_mail(outbound_mail)
  puts "sending to #{outbound_mail.address}"
  STDOUT.flush
  mailing    = nil
  message    = outbound_mail.distribution.message
  address    = outbound_mail.email_address
  full_label = outbound_mail.full_label
  dist       = outbound_mail.distribution
  format     = message.format
  opts       = Notifier.set_optz(message, address, full_label, dist)
  mailing    = render_email_message(opts, format) if outbound_mail.email
  mailing    = render_phone_message(opts, format) if outbound_mail.phone
  unless mailing.nil?
    mailing.deliver
    invoke_url = "api/rake/messages/#{outbound_mail.id}/sent_at_now.json"
    cmd        = curl_get(invoke_url)
    system cmd
  end
end

      #def send_mail(outbound_mail)
      #  puts "sending message for #{outbound_mail.address}"
      #  STDOUT.flush
      #  label = outbound_mail.label
      #  file  = "/tmp/render_msg/#{label}"
      #  return unless File.exist?(file)
      #  mailing = Mail.new(YAML.load_file(file))
      #  debugger
      #  unless mailing.nil?
      #    mailing.deliver
      #    invoke_url = "api/rake/messages/#{outbound_mail.id}/sent_at_now.json"
      #    cmd        = curl_get(invoke_url)
      #    system cmd
      #  end
      #end

# ----- Rake Tasks -----

namespace :ops do
  namespace :email do

    namespace :pending do

      desc "Count Pending Mails"
      task :count => 'environment' do
        count = OutboundMail.pending.count
        puts "Pending Outbound Mails: #{count}"
        STDOUT.flush
      end

      desc "Render Pending Mails"
      task :render => 'environment' do
        system "mkdir -p /tmp/render_msg; rm -f /tmp/render_msg/*"
        Time.zone = "Pacific Time (US & Canada)"
        mails     = OutboundMail.pending.all
        mails.each { |om| sleep 0.5; render_mail(om) }
        STDOUT.flush
      end

      desc "Send Pending Mails"
      task :send => 'environment' do
        Time.zone = "Pacific Time (US & Canada)"
        send_list = CarrierQueueCollection.new
        mails     = OutboundMail.pending.all
        mails.each { |om| send_list.add(om) }
        while send_obj = send_list.get
          send_mail(send_obj)
        end
        STDOUT.flush
      end

      desc "Send Pending Mails V2"
      task :send2 do
        require 'mail'
        require 'letter_opener'
        Mail.defaults do
          delivery_method LetterOpener::DeliveryMethod, :location => "/tmp/letter_opener"
        end
        module LetterOpener
          class DeliveryMethod
            def settings
              ""
            end
          end
        end
        require 'gmail'
        require 'yaml'
        Time.zone = "Pacific Time (US & Canada)"
        gmail_service = Gmail.new(GMAIL_USER, GMAIL_PASS)
        Dir.glob("/tmp/render_msg/*").each do |file|
          sleep 1
          mail  = Mail.new(YAML.load_file(file))
          msgid = file.split('/').last.split('_').first
          puts "sending message #{msgid}"
          if ENV['SYSNAME'] == 'ekel'
            mail.deliver!
          else
            orig_stderr = $stderr
            $stderr = File.new('/dev/null', 'w')
            gmail_service.deliver(mail)
            $stderr = orig_stderr
          end
          unless msgid.blank?
            invoke_url = "api/rake/messages/#{msgid}/sent_at_now.json"
            cmd        = curl_get(invoke_url)
            system cmd
          end
          system "rm -f #{file}"
        end
        gmail_service.logout
      end

    end

    # ----- Inbound Pager Messages -----

    desc "Load inbound emails from our gmail account"
    task :import => 'environment' do
      check_host_and_run_frequency
      get_all_emails_from_gmail
      load_all_emails_into_database
    end

    namespace :generate do

      # ----- Password Reset -----

      desc "Password Reset ADDRESS=<email_address>"
      task :password_reset => 'environment' do
        adr = ENV["ADDRESS"]
        cmd = curl_get("api/rake/password/reset?address=#{adr}")
        puts "Generating password reset mail for #{adr} at #{Time.now}"
        system cmd
      end

      # ----- DO Mails -----

      # sent 4 days before the shift starts
      desc "DO Shift Pending Reminder"
      task :do_shift_pending => 'environment' do
        cmd = curl_get('api/rake/reminders/do_shift_pending')
        puts "Generating DO Shift Pending Reminder"
        system cmd
      end

      # sent 1 hours before the shift starts
      desc "DO Shift Starting Alert"
      task :do_shift_starting => 'environment' do
        cmd = curl_get('api/rake/reminders/do_shift_starting')
        puts "Generating DO Shift Starting Reminder"
        system cmd
      end

      # ----- Cert Reminder Mails -----

      desc "Cert Expiration Notices"
      task :cert_notices => 'environment' do
        cmd = curl_get('api/rake/reminders/cert_expiration')
        puts "Generating Cert Expiration Notice"
        system cmd
      end

    end
  end
end
