class Eapi::Events::EventFilesController < ApplicationController
  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/eapi/events/<event_id>/event_files.json
  def index
    files = EventFileSvc.find_by_event(params["event_id"])
    respond_with files, opts
  end
  
  def show
    respond_with DataFile.find(params[:id])
  end

  # curl -u <first>_<last>:<pwd> -X POST http://server/eapi/events/<event_id>/event_files.json
  def create
    event_file = EventFileSvc.create(params[:event_file])
    respond_with event_file
  end

  # curl -u <first>_<last>:<pwd> -X PUT http://server/eapi/events/<event_id>/event_files/<id>.json -d
  def update
    svc = EventFileSvc.find(params[:id])
    respond_with svc.update_attributes({caption: params["caption"]})
  end

  # curl -u <first>_<last>:<pwd> -X DELETE http://server/eapi/events/<event_id>/event_files/<id>.json
  def destroy
    svc = EventFileSvc.find(params[:id])
    respond_with svc.destroy
  end

  private

  def opts
    xopts = [:created_at]

    {except: xopts}
  end

end