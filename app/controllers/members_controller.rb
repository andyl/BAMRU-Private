class MembersController < ApplicationController
  def index
    @members = Member.all
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
      redirect_to edit_member_path(@member)
    end
    
  end
end
