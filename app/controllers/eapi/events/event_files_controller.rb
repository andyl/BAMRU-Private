class Eapi::Events::EventFilesController < ApplicationController
  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/eapi/events/<event_id>/event_files.json
  def index
    event = Event.find(params["event_id"])
    respond_with event.data_files, opts
  end
  
  def show
    respond_with DataFile.find(params[:id])
  end

  # curl -u <first>_<last>:<pwd> -X POST http://server/eapi/events/<event_id>/event_files.json
  def create
    event_file = EventFileSvc.new(params[:event_file])
    #respond_with event_file, opts
    respond_with event_file, opts
  end

  # curl -u <first>_<last>:<pwd> -X PUT http://server/eapi/events/<event_id>/event_files/<id>.json -d
  def update
    respond_with DataFile.update(params[:id], params[:event_file])
  end

  # curl -u <first>_<last>:<pwd> -X DELETE http://server/eapi/events/<event_id>/event_files/<id>.json
  def destroy
    respond_with DataFile.destroy(params[:id])
  end

  private

  def opts
    xopts = [:created_at, :position, :published, :data_content_type,
             :data_file_size, :data_file_extension,
             :download_count, :data_file_content_type,
             :data_updated_at]

    {except: xopts}
  end

end