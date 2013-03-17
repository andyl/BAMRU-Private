class Eapi::Events::EventPhotosController < ApplicationController
  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/eapi/events/<event_id>/event_photos.json
  def index
    event = Event.find(params["event_id"])
    respond_with event.event_photos, opts
  end
  
  def show
    respond_with EventPhoto.find(params[:id])
  end
  
  def create
    event_photo = EventPhoto.create(params[:event_photo])
    respond_with event_photo, opts
  end
  
  def update
    respond_with EventPhoto.update(params[:id], params[:event_photo])
  end
  
  def destroy
    respond_with EventPhoto.destroy(params[:id])
  end

  private

  def opts
    xopts = [:created_at, :position, :published,
             :image_file_name,       :image_file_size,
             :image_content_type,    :image_updated_at]
    methods = [:original_url, :thumb_url, :icon_url]

    {except: xopts, methods: methods}
  end

end