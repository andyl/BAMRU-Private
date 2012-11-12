require_relative '../faye_module'

class Eapi::Events::PeriodsController < ApplicationController
  include Eapi::FayeModule
  respond_to :json

  def index
    event = Event.find(params["event_id"])
    respond_with event.periods, opts
  end
  
  def show
    respond_with Period.find(params[:id])
  end
  
  def create
    new_period = Period.create(params[:period])
    broadcast("add", new_period)
    render :json => new_period
  end
  
  def update
    updated_period = Period.update(params[:id], params[:period])
    broadcast("update", updated_period)
    respond_with updated_period
  end
  
  def destroy
    broadcast("destroy")
    respond_with Period.destroy(params[:id])
  end

  private

  def opts
    {except: [:updated_at, :created_at]}
  end

end