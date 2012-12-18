class EventsController < ApplicationController

  before_filter :authenticate_member!
  caches_action :index

  def index
    @session_id  = session["session_id"]
    @event_json  = Event.all.to_json except: [:created_at, :updated_at]
    @member_json = current_member.to_json only: [:id, :first_name, :last_name, :typ, :admin, :developer]
  end

end
