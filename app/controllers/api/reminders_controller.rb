require "reminder_params"

class Api::RemindersController < ApplicationController

  respond_to :xml, :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/api/reminders/do_reminder.json
  def do_shift_pending
    member  = DoAssignment.next_wk.first.primary
    params  = ReminderParams.do_shift_pending(member)
    message = Message.create(params)
    message.create_all_outbound_mails
    render :json => "OK\n"
  end

  # curl -u <first>_<last>:<pwd> http://server/api/reminders/do_alert.json
  def do_shift_started
    member  = DoAssignment.this_wk.first.primary
    params  = ReminderParams.do_shift_started(member)
    message = Message.create(params)
    message.create_all_outbound_mails
    render :json => "OK\n"
  end

  # curl -u <first>_<last>:<pwd> http://server/api/reminders/cert_reminders.json
  def cert_expiration
    expire_count = 0
    Cert.expired_not_notified.all.each do |cert|
      params = ReminderParams.cert_notice(cert, "has expired")
      message = Message.create(params)
      message.create_all_outbound_mails
      cert.update_attributes({:expired_notice_sent_at => Time.now})
      expire_count += 1
    end
    thirty_count = 0
    Cert.thirty_day_not_notified.all.each do |cert|
      params = ReminderParams.cert_notice(cert, "will expire within thirty days")
      message = Message.create(params)
      message.create_all_outbound_mails
      cert.update_attributes({:thirty_day_notice_sent_at => Time.now})
      thirty_count += 1
    end
    ninety_count = 0
    Cert.ninety_day_not_notified.all.each do |cert|
      params = ReminderParams.cert_notice(cert, "will expire within ninety days")
      message = Message.create(params)
      message.create_all_outbound_mails
      cert.update_attributes({:ninety_day_notice_sent_at => Time.now})
      ninety_count += 1
    end
    render :json => "OK (ninety:#{ninety_count} thirty:#{thirty_count} expired:#{expire_count})\n"
  end

end
