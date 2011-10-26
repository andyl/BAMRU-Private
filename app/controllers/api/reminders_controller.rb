requrie "reminder_params"

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
    #member = Member.new
    #message = Message.create
    #message.create_all_outbound_mails
    render :json => "OK\n"
  end

  # curl -u <first>_<last>:<pwd> http://server/api/reminders/cert_reminders.json
  def cert_expiration
    render :json => "OK\n"
  end

end
