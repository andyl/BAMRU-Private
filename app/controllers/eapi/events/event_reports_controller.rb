class Eapi::Events::EventReportsController < ApplicationController
  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  def index
    event = Event.find(params["event_id"])
    respond_with event.event_reports, opts
  end
  
  def show
    respond_with EventReport.find(params[:id])
  end
  
  def create
    event_report = EventReport.create(params[:event_report])
    respond_with event_report, opts
  end
  
  def update
    respond_with EventReport.update(params[:id], params[:event_report])
  end
  
  def destroy
    respond_with EventReport.destroy(params[:id])
  end

  private

  def opts
    xopts = [:created_at]

    {except: xopts}
  end

end