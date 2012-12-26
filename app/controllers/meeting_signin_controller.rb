class MeetingSigninController < ApplicationController

  before_filter :authenticate_member!

  def index
    @is_phone      = phone_device?
    @device_name   = device_name
    @session_id    = session["session_id"]
    @members_json  = MemberDecorator.signin_json
    @meetings_json = EventDecorator.signin_meetings
    render :layout => false
  end

end
