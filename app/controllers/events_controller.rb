class EventsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @session_id  = session["session_id"]
    @member_json = current_member.to_json only: [:id, :first_name, :last_name, :typ, :admin, :developer]
  end

end
