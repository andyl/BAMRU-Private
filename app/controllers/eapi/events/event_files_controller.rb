class Eapi::Events::EventFilesController < ApplicationController
  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  def index
    event = Event.find(params["event_id"])
    respond_with event.data_files, opts
  end
  
  def show
    respond_with DataFile.find(params[:id])
  end
  
  def create
    event_file = DataFile.create(params[:event_file])
    respond_with event_file, opts
  end
  
  def update
    respond_with DataFile.update(params[:id], params[:event_file])
  end
  
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