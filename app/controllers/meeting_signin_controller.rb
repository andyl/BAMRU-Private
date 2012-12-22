class MeetingSigninController < ApplicationController

  before_filter :authenticate_member!

  def index
    @is_ipad  = ipad_device?
    @is_phone = phone_device?
    @session_id    = session["session_id"]
    @member_json   = current_member.to_json only: [:id, :first_name, :last_name, :typ]
    @meetings_json = EventDecorator.current_meetings
    render :layout => false
  end

end
