class Eapi::Events::PeriodsController < ApplicationController
  respond_to :json

  def index
    event = Event.find(params["event_id"])
    respond_with event.periods, opts
  end
  
  def show
    respond_with Period.find(params[:id])
  end
  
  def create
    render :json => Period.create(params[:period])
  end
  
  def update
    respond_with Period.update(params[:id], params[:period])
  end
  
  def destroy
    respond_with Period.destroy(params[:id])
  end

  private

  def opts
    {except: [:updated_at, :created_at]}
  end

end