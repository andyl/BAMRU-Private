class OotsController < ApplicationController

  def index
    @member = Member.where(:id => params['member_id']).first
  end
  
  def new
    @member = Member.where(:id => params['member_id']).first
    @oot   = Oot.new
  end

  def create
    @member = Member.where(:id => params['member_id']).first
    @oot    = Oot.create(params[:oot])
    @member.oots << @oot
    @member.save
    redirect_to member_oots_path(@member)
  end

end
