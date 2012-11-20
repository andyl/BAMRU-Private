class GuestsController < ApplicationController

  def index
    @guests = Member.guests
  end
  
  def show
    @guest = Member.find(params[:id])
    @meetings  = @guest.events.where typ: 'meeting'
    @trainings = @guest.events.where typ: 'training'
  end

  def edit
    @guest = Member.find(params[:id])
    @autoselect_member_names = Member.autoselect_member_names('/edit')
    @guest.password = ""
    @guest_name = @guest.full_name
  end
  
  def create
    render :json => Member.create(params[:Member])
  end
  
  def update
    respond_with Member.update(params[:id], params[:Member])
  end
  
  def destroy
    respond_with Member.destroy(params[:id])
  end

end