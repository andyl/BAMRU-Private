# require 'carrier_queue'
# require 'rake_util'
# require File.expand_path("../../lib/env_settings", File.dirname(__FILE__))
#
# include RakeUtil
#
# # ----- Utilities for Rake Tasks -----
#
# def check_host_and_run_frequency
#   file = "tmp/mail_sync_time.txt"
#   if File.exists?(file)
#     if last_update_less_than_two_minutes_ago(file)
#       puts "Exiting: last mail sync was less than two minutes ago."
#       exit
#     end
#   end
#   File.open(file, 'w') { |f| f.puts Time.now.strftime("%m-%d %H:%M:%S") }
# end
#
# # ----- Methods for Importing Mail -----
#
# def last_update_less_than_two_minutes_ago(file)
#   (Time.now - File.new(file).mtime) < (60 * 2)
# end
#
# def get_all_emails_from_gmail
#   Time.zone = "Pacific Time (US & Canada)"
#   gm = Gmail.new(GMAIL_USER, GMAIL_PASS)
#   gm.inbox.emails.each do |email|
#     puts "Caching mail #{email.uid}"
#     STDOUT.flush
#     write_email_to_disk(email)
#     email.archive!
#   end
#   gm.logout
# end
#
# def mail_dir
#   dir = Rails.root.to_s + "/tmp/inbound_mails"
#   system "mkdir -p #{dir}"
#   dir
# end
#
# def write_email_to_disk(mail)
#   mail_file = "#{mail_dir}/#{Time.now.strftime("inbound_%y%m%d_%H%M%S")}.yaml"
#   opts = {}
#   opts[:subject]   = mail.subject
#   opts[:from]      = mail.from.join(' ')
#   opts[:to]        = mail.to.join(' ')
#   opts[:uid]       = mail.try(:uid)
#   opts[:body]      = mail.body.to_s.lstrip
#   opts[:send_time] = mail.date.to_s
#   File.open(mail_file, 'w') {|f| f.puts opts.to_yaml }
# end
#
# def load_all_emails_into_database
#   cmd = curl_get("api/rake/messages/load_inbound")
#   puts "Loading emails into database..."
#   system cmd
# end
#
# # ----- Rake Tasks -----
#
# namespace :ops do
#   namespace :email do
#
#     namespace :pending do
#
#       desc "Count Pending Mails"
#       task :count do
#         puts "going to issue an api call here..."
#         STDOUT.flush
#       end
#
#       desc "Send Pending Mails"
#       task :send do
#         require 'queue_classic'
#         puts "Sending pending messages"
#         QC.enqueue "QcMail.send_pending"
#       end
#
#     end
#
#     # ----- Inbound Pager Messages -----
#
#     desc "Load inbound emails from our gmail account"
#     task :import => 'environment' do
#       check_host_and_run_frequency
#       get_all_emails_from_gmail
#       load_all_emails_into_database
#     end
#
#     namespace :generate do
#
#       # ----- Password Reset -----
#
#       desc "Password Reset ADDRESS=<email_address>"
#       task :password_reset => :environment do
#         adr = ENV["ADDRESS"]
#         cmd = curl_get("api/rake/password/reset?address=#{adr}")
#         puts "Generating password reset mail for #{adr} at #{Time.now}"
#         system cmd
#       end
#
#       # ----- DO Mails -----
#
#       # sent 4 days before the shift starts
#       desc "DO Shift Pending Reminder"
#       task :do_shift_pending => :environment do
#         cmd = curl_get('api/rake/reminders/do_shift_pending')
#         puts "Generating DO Shift Pending Reminder"
#         system cmd
#       end
#
#       # sent 1 hours before the shift starts
#       desc "DO Shift Starting Alert"
#       task :do_shift_starting => 'environment' do
#         cmd = curl_get('api/rake/reminders/do_shift_starting')
#         puts "Generating DO Shift Starting Reminder"
#         system cmd
#       end
#
#       # ----- Cert Reminder Mails -----
#
#       desc "Cert Expiration Notices"
#       task :cert_notices => 'environment' do
#         cmd = curl_get('api/rake/reminders/cert_expiration')
#         puts "Generating Cert Expiration Notice"
#         system cmd
#       end
#
#     end
#   end
# end
