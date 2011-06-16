class DoAssignmentsController < ApplicationController

  before_filter :authenticate_member!

  def index
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

  def edit
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
    @org = Org.where(:name => "BAMRU").first
    if @org.update_attributes(params["org"])
      redirect_to edit_do_assignment_path(@org), :notice => "Records Saved"
    else
      render "edit"
    end
  end
end
