class Eapi::Events::EventPhotosController < ApplicationController
  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/eapi/events/<event_id>/event_photos.json
  def index
    photos = EventPhotoSvc.find_by_event(params["event_id"])
    respond_with photos, opts
  end
  
  def show
    respond_with DataPhoto.find(params[:id])
  end
  
  def create
    event_photo = EventPhotoSvc.create(params[:event_photo])
    respond_with event_photo
  end
  
  def update
    svc = EventPhotoSvc.find(params[:id])
    respond_with svc.update_attributes({caption: params["caption"]})
  end
  
  def destroy    svc = EventPhotoSvc.find(params[:id])
    respond_with svc.destroy

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