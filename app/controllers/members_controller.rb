class MembersController < ApplicationController
  def index
    @client_ip = request.remote_ip
    @message = Message.new
    @members = Member.order("last_name ASC").all
  end

  def show
    @member = Member.where(:id => params[:id]).first
  end

  def edit
    @member = Member.where(:id => params[:id]).first
  end

  def update
    @member = Member.where(:id => params[:id]).first
    if @member.update_attributes(params["member"])
      redirect_to member_path(@member)
    else
      render "edit"
#      redirect_to edit_member_path(@member)
    end
    
  end
end
