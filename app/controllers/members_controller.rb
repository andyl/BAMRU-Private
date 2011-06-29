class MembersController < ApplicationController

  before_filter :authenticate_member!

  def index
    @client_ip = request.remote_ip
    @message = Message.new
    @members = Member.order_by_last_name.all
  end

  def show
    @autoselect_member_names = Member.autoselect_member_names
    @member = Member.where(:id => params[:id]).first
  end

  def new
    @autoselect_member_names = Member.autoselect_member_names
    @member = Member.new(:first_name => "New", :last_name => "Name", :typ => "T")
    authorize! :manage, @member
  end

  def edit
    @autoselect_member_names = Member.autoselect_member_names('/edit')
    @member = Member.where(:id => params[:id]).first
    @member.password = ""
    @member_name = @member.full_name
    authorize! :manage, @member
  end

  def create
    authorize! :manage, Member
    if @member = Member.create(params["member"])
      redirect_to edit_member_path(@member), :notice => "Please add Contact Info !!"
    else
      render "new"
    end
  end

  def update
    @member = Member.where(:id => params[:id]).first
    @member_name = @member.full_name
    authorize! :manage, @member
    m_params = params["member"]
    if m_params["password"].blank? && m_params["password_confirmation"].blank?
      m_params.delete("password"); m_params.delete("password_confirmation")
    end
    x = @member.update_attributes(m_params)
    if x
      redirect_to member_path(@member), :notice => "Successful Update"
    else
      render "edit"
    end
  end

  def destroy
    @member = Member.where(:id => params[:id]).first
    authorize! :manage, @member
    if @member.destroy
      redirect_to '/members', :notice => "Member was Deleted"
    else
      render "show"
    end
  end
  
end
