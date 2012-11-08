class Eapi::EventsController < ApplicationController
  respond_to :json

  def index
    respond_with Event.all, opts
  end
  
  def show
    respond_with Event.find(params[:id])
  end
  
  def create
    new_event = Event.create(params[:event])
    lcast("add", params, new_event)
    render :json => new_event
  end
  
  def update
    updated_event = Event.update(params[:id], params[:event])
    lcast("update", params, updated_event)
    respond_with updated_event
  end
  
  def destroy
    lcast('destroy', params, nil)
    respond_with Event.destroy(params[:id])
  end

  private

  def lcast(action, params, event)
    %w(event controller action).each {|x| params.delete(x)}
    msg = {
        action:    action,
        eventid:   event.try(:id) || params[:id],
        params:    params,
        sessionid: session["session_id"],
        userid:    current_member.id
    }
    do_cast("/events", msg.to_json)
  end

  def do_cast(channel, string)
    message = {:channel => channel, :data => string}
    uri = URI.parse("#{FAYE_SERVER}/faye")
    status = Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def opts
    {except: [:created_at, :updated_at]}
  end

end