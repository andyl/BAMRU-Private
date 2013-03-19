class Eapi::Events::EventLinksController < ApplicationController
  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  def index
    photos = EventLinkSvc.find_by_event(params["event_id"])
    respond_with photos, opts
  end
  
  def show
    respond_with DataLink.find(params[:id])
  end
  
  def create
    params.delete_if { |key,_| ! %w(member_id event_id site_url caption).include? key }
    event_link = EventLinkSvc.create(params)
    respond_with event_link
  end
  
  def update
    svc = EventLinkSvc.find(params[:id])
    respond_with svc.update_attributes({site_url: params["site_url"], caption: params["caption"]})
  end
  
  def destroy
    svc = EventLinkSvc.find(params[:id])
    respond_with svc.destroy
  end

  private

  def opts
    {except: [:created_at]}
  end

end