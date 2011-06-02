class AvailOpsController < ApplicationController

  def index
    @member = Member.where(:id => params['member_id']).first
  end
  
  def new
    @member = Member.where(:id => params['member_id']).first
    @avail   = AvailOp.new
  end

  def create
    @member = Member.where(:id => params['member_id']).first
    @avail    = AvailOp.create(params[:member_avail])
    @member.member_avails << @avail
    @member.save
    redirect_to member_avails_path(@member)
  end

end
