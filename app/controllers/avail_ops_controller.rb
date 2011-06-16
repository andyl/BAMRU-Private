class AvailOpsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @member = Member.where(:id => params['member_id']).first
  end
  
  def new
    @member = Member.where(:id => params['member_id']).first
    @avail   = @member.avail_ops.create
    redirect_to member_avail_ops_path(@member), :notice => "Created Busy Period"
  end

  def create
    @member = Member.where(:id => params['member_id']).first
    @avail    = AvailOp.create(params[:member_avail])
    @member.member_avails << @avail
    @member.save
    redirect_to member_avails_path(@member)
  end

  def destroy
    @member = Member.where(:id => params['member_id']).first
    @avail  = AvailOp.where(:id => params['id']).first
    @avail.destroy
    redirect_to member_avail_ops_path(@member), :notice => "Deleted Busy Period"
  end

end
