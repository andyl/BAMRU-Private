class AvailDosController < ApplicationController

  before_filter :authenticate_member!

  def index
    @member = Member.where(:id => params['member_id']).first
    @quarter = {
            :year      => Time.now.year,
            :quarter   => Time.now.current_quarter
    }
    @avail_set = [1..13].map do |num|
      quarter = @quarter.clone
      quarter[:week] = num
      quarter[:member_id] = @member.id
      @member.avail_dos.find_or_new(quarter)
    end
  end

  def create
    @member = Member.where(:id => params['member_id']).first
    if @member.update_attributes(params["member"])
      redirect_to member_avail_dos_path(@member), :notice => "Records Saved"
    else
      render "edit"
    end
  end
end
