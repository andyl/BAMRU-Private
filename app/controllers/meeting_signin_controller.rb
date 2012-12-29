class MeetingSigninController < ApplicationController

  before_filter :authenticate_mobile_member!

  def index
    @is_phone      = phone_device?
    @device_name   = device_name
    @session_id    = session["session_id"]
    @meetings_json = EventDecorator.signin_meetings
    @members_json  = MemberDecorator.signin_json
    render :layout => false
  end

  private

  def opts
    {only: [:id, :first_name, :last_name, :typ, :admin, :developer], methods: :photo_icon}
  end

end
