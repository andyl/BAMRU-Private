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
      debugger
      render "edit"
    end
  end
  
end
