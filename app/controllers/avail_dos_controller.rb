class AvailDosController < ApplicationController

  before_filter :authenticate_member!

  def index
    @member = Member.where(:id => params['member_id']).first
    @quarter = {
      :year    => params["year"].try(:to_i)    || Time.now.year,
      :quarter => params["quarter"].try(:to_i) || Time.now.current_quarter
    }
    @avail_set = (1..13).map do |num|
      quarter = @quarter.clone
      quarter[:week] = num
      quarter[:member_id] = @member.id
      @member.avail_dos.find_or_new(quarter)
    end
  end

  def create
    @member = Member.where(:id => params['member_id']).first
    if @member.update_attributes(params["member"])
      hash = {}
      cy = params['member']['current_year']
      cq = params['member']['current_quarter']
      hash = {:year => cy, :quarter => cq} if (cy && cq)
      redirect_to(hash, {:notice => "Records Saved"})
    else
      render "edit"
    end
  end
end
