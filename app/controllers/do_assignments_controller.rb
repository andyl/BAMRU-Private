class DoAssignmentsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @org = Org.where(:name => "BAMRU").first
    @quarter = {
            :year      => params["year"].try(:to_i)    || Time.now.year,
            :quarter   => params["quarter"].try(:to_i) || Time.now.current_quarter
    }
    @current_week    = Time.now.current_week
    @current_quarter = Time.now.current_quarter
    @do_assignments = (1..13).map do |num|
      quarter = @quarter.clone
      quarter[:org_id] = 1
      quarter[:week] = num
      @org.do_assignments.find_or_new(quarter)
    end
  end

  def edit
    expire_fragment('footer-table')
    @org = Org.where(:name => "BAMRU").first
    @quarter = {
            :year      => params["year"].try(:to_i)    || Time.now.year,
            :quarter   => params["quarter"].try(:to_i) || Time.now.current_quarter
    }
    @do_assignments = (1..13).map do |num|
      quarter = @quarter.clone
      quarter[:org_id] = 1
      quarter[:week] = num
      @org.do_assignments.find_or_new(quarter)
    end
  end

  def create
    expire_fragment('footer-table')
    expire_fragment('member_index_table-all')
    expire_fragment('member_index_table-active')
    @org = Org.where(:name => "BAMRU").first
    if @org.update_attributes(params["org"])
      Member.set_do
      redirect_to do_assignments_path(@org), :notice => "Records Saved"
    else
      render "edit"
    end
  end
end
