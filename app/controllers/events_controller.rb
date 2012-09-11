class EventsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @action  = "index"
    @eventid = 0
  end

  def show
    @action = "show"
    @event  = Event.find(params[:id])
    layout = request.headers['X-PJAX'] ? false : "application"
    render :layout => layout
  end

  def sidebar
    @start  = Event.date_parse(select_start_date)
    @finish = Event.date_parse(select_finish_date)
    @start, @finish  = @finish, @start if @finish < @start
    get_events(@start, @finish)
    render :layout => false
  end

  def create
    @member = current_member
    @file    = DataFile.create(params[:data_file])
    @member.data_files << @file
    if @member.save
      redirect_to files_path, :notice => "File saved (#{@file.data_file_name})"
    else
      string = @file.errors.full_messages.join(', ')
      flash.now.alert = "Error: #{string}"
      render "new"
    end
  end

  def destroy
    @file = DataFile.where(:id => params['id']).first
    @file.destroy
    redirect_to files_path, :notice => "File was Deleted"
  end

  private

  def get_events(start, finish)
    @events = Event.between(start, finish)
  end

  def select_start_date
    params[:start]  || cookies[:start]  ||  Event.default_start
  end

  def select_finish_date
    params[:finish] || cookies[:finish] || Event.default_end
  end


end
