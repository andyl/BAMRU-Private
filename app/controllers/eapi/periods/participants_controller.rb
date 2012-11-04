class Eapi::Periods::ParticipantsController < ApplicationController
  respond_to :json

  def index
    period = Period.find(params["period_id"])
    respond_with period.participants, opts
  end
  
  def show
    respond_with Participant.find(params[:id])
  end
  
  def create
    new_participant = Participant.create(params[:participant])
    lcast("add", params, new_participant)
    render :json => new_participant
  end

  def update
    updated_participant = Participant.update(params[:id], params[:participant])
    lcast("update", params, updated_participant)
    respond_with updated_participant
  end
  
  def destroy
    lcast('destroy', params, nil)
    respond_with Participant.destroy(params[:id])
  end

  private

  def lcast(action, params, event)
    %w(event controller action).each {|x| params.delete(x)}
    period_id = params["period_id"]
    msg = {
        action:          action,
        periodid:        period_id,
        participantid:   event.try(:id) || params[:id],
        params:          params,
        sessionid:       session["session_id"],
        userid:          current_member.id
    }
    do_cast("/periods/#{period_id}/participants", msg.to_json)
  end

  def do_cast(channel, string)
    message = {:channel => channel, :data => string}
    uri = URI.parse("#{FAYE_SERVER}/faye")
    status = Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def opts
    {except: [:updated_at, :created_at]}
  end

end