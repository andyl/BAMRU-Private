require_relative '../faye_module'

class Eapi::Periods::ParticipantsController < ApplicationController
  include Eapi::FayeModule
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
    broadcast("add", new_participant)
    render :json => new_participant
  end

  def update
    updated_participant = Participant.update(params[:id], params[:participant])
    broadcast("update", updated_participant)
    respond_with updated_participant
  end
  
  def destroy
    broadcast("destroy")
    respond_with Participant.destroy(params[:id])
  end

  private

  def opts
    {except: [:created_at]}
  end

end