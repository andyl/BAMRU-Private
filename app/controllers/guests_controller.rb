class GuestsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @guests = if cookies['gx_show'] == 'true'
                Member.all_guests include: [:photos]
              else
                Member.guests include: [:photos]
              end
  end
  
  def show
    @guest = Member.find(params[:id])
    @meetings  = @guest.events.where typ: 'meeting'
    @trainings = @guest.events.where typ: 'training'
  end

  def edit
    @guest = Member.find(params[:id])
    @guest.addresses.first || @guest.addresses.build
    @guest.phones.first    || @guest.phones.build
    @guest.emails.first    || @guest.emails.build
    @autoselect_member_names = Member.autoselect_member_names('/edit')
    @guest.password = ""
    @guest_name = @guest.full_name
  end

  def new
    @guest = Member.new
    @guest.addresses.build
    @guest.phones.build
    @guest.emails.build
  end

  def new_form
    @guest = Member.new
    @guest.addresses.build
    @guest.phones.build
    @guest.emails.build
    render :layout => false
  end
  
  def create
    @guest = Member.create(params["member"])
    if @guest.valid?
      expire_fragment(/guest_index_table/)
      expire_fragment(/event_members_fragment/)
      ActiveSupport::Notifications.instrument("alert.CreateGuest", {:member => current_member, :tgt => @guest})
      redirect_to guest_path(@guest), :notice => "Guest Created"
    else
      render "new"
    end
  end
  
  def update
    @guest = Member.where(:id => params[:id]).first
    @guest_name = @guest.full_name
    m_params = params["member"]
    if m_params["password"].blank? && m_params["password_confirmation"].blank?
      m_params.delete("password"); m_params.delete("password_confirmation")
    end
    x = @guest.update_attributes(m_params)
    if x
      expire_fragment(/guests_index_table/)
      expire_fragment(/event_members_fragment/)
      if @guest.previous_changes.keys.include? "typ"
        ActiveSupport::Notifications.instrument("alert.UpdateGuestRole", {:member => current_member, :tgt => @guest})
      end
      redirect_to guest_path(@guest), :notice => "Successful Update"
    else
      render "edit"
    end
  end
  
  def destroy
    expire_fragment(/guest_index_table/)
    expire_fragment(/event_members_fragment/)
    Member.destroy(params[:id])
    redirect_to guests_path, :notice => "Guest was Deleted"
  end

end