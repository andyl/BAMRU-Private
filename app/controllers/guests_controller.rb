class GuestsController < ApplicationController

  def index
    @guests = if cookies['gx_show'] == 'true'
                Member.all_guests
              else
                Member.guests
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
  
  def create
    @guest = Member.create(params["member"])
    if @guest.valid?
      expire_fragment(/member_index_table/)
      expire_fragment(/unit_certs_table/)
      expire_fragment(/unit_avail_ops_table/)
      expire_fragment('unit_photos_table')
      redirect_to guest_path(@guest), :notice => "Successful Update"
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
      expire_fragment(/member_index_table/)
      expire_fragment(/unit_certs_table/)
      expire_fragment(/unit_avail_ops_table/)
      expire_fragment('unit_photos_table')
      redirect_to guest_path(@guest), :notice => "Successful Update"
    else
      render "edit"
    end
  end
  
  def destroy
    Member.destroy(params[:id])
    redirect_to guests_path, :notice => "Guest was Deleted"
  end

end