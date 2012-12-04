class Eapi::Events::EventPhotosController < ApplicationController
  respond_to :json

  def index
    event = Event.find(params["event_id"])
    respond_with event.event_photos, opts
  end
  
  def show
    respond_with EventPhoto.find(params[:id])
  end
  
  def create
    render :json => EventPhoto.create(params[:event_photo])
  end
  
  def update
    respond_with EventPhoto.update(params[:id], params[:event_photo])
  end
  
  def destroy
    respond_with EventPhoto.destroy(params[:id])
  end

  private

  def opts
    {except: [:created_at]}
  end

end