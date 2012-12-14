require_relative './faye_module'

class Eapi::EventsController < ApplicationController
  include Eapi::FayeModule
  respond_to :json

  def index
    respond_with Event.all, opts
  end
  
  def show
    respond_with Event.find(params[:id])
  end
  
  def create
    new_event = Event.create(params[:event])
    broadcast("add", new_event)
    QC.enqueue('QcCalendar.csv_resync')
    QC.enqueue('QcGcal.create_event_id', new_event.id)
    render :json => new_event
  end
  
  def update
    updated_event = Event.update(params[:id], params[:event])
    broadcast("update", updated_event)
    QC.enqueue('QcCalendar.csv_resync')
    QC.enqueue('QcGcal.update_event_id', updated_event.id)
    respond_with updated_event
  end
  
  def destroy
    broadcast('destroy')
    QC.enqueue('QcCalendar.csv_resync')
    QC.enqueue('QcGcal.delete_event', params[:id])
    respond_with Event.destroy(params[:id])
  end

  private

  def opts
    {except: [:created_at, :updated_at]}
  end

end