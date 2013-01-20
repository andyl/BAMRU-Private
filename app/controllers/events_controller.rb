class EventsController < ApplicationController

  before_filter :authenticate_member!
  # before_filter :authenticate_member_with_basic_auth!
  # test with curl -u user_name:pass http://bamru.net/reports -I

  def index
    @session_id  = session["session_id"]
    @members     = Member.scoped
    @events      = Event.scoped
    @member_json = current_member.to_json only: [:id, :first_name, :last_name, :typ, :admin, :developer]
    max_mem = @members.maximum(:updated_at)
    max_evt = @events.maximum(:updated_at)
    fresh_when last_modified: [max_mem, max_evt].max
  end

end
