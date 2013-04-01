class RegistryController < ApplicationController

  before_filter :authenticate_member!

  def index
  end

  def roles
  end

  def alerts
  end

  def members
    @label   = "Member"
    @members = Member.registered.standard_order
  end

  def member_alums
    @label   = "Member Alum"
    @members = Member.member_alums
    render "members"
  end

  def member_ncs
    @label   = "Member NoContact"
    @members = Member.member_no_contact
    render "members"
  end

  def guests
    @label   = "Member Guest"
    @members = Member.guests
    render "members"
  end

  def guest_alums
    @label   = "Member Guest-Alum"
    @members = Member.guest_alums
    render "members"
  end

  def guest_ncs
    @label   = "Member Guest-NoContact"
    @members = Member.guest_no_contact
    render "members"
  end

  def show
    @member = Member.find(params[:id])
    @meetings   = @member.events.where typ: 'meeting'
    @trainings  = @member.events.where typ: 'training'
    @operations = @member.events.where typ: 'operation'
    @community  = @member.events.where typ: 'community'
  end

  def update
    @member = Member.find params[:id]
    @member_name = @member.full_name
    m_params = params["member"]
    notice_msg = if @member.update_attributes(m_params)
      expire_fragment(/guests_index_table/)
      expire_fragment(/event_members_fragment/)
      lbl = @member.is_guest ? "Guest" : "Member"
      ActiveSupport::Notifications.instrument("alert.Update#{lbl}Role", {:member => current_member, :tgt => @guest})
      "Successful Update"
    else
      "Unsuccessful Update"
    end
    redirect_to "/registry/show/#{@member.id}", :notice => notice_msg
  end

end