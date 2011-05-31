class MembersController < ApplicationController
  def index
    @client_ip = request.remote_ip
    @message = Message.new
    @members = Member.order_by_last_name.all
  end

  def show
    @autoselect_member_names = Member.autoselect_member_names
    @member = Member.where(:id => params[:id]).first
  end

  def edit
    @autoselect_member_names = Member.autoselect_member_names('/edit')
    @member = Member.where(:id => params[:id]).first
  end

  def update
    @member = Member.where(:id => params[:id]).first
    if @member.update_attributes(params["member"])
      redirect_to member_path(@member), :notice => "Successful Update"
    else
      alert "Something is Wrong"
      render "edit"
    end
  end
  
  def sort
    puts params
    debugger
    redirect_to edit_member_path(params['member_id'])
  end
end
