class DoAssignmentsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @org = Org.where(:name => "BAMRU").first
    @hash = {
            :org_id => @org.id,
            :year      => params["year"].try(:to_i)    || Time.now.year,
            :quarter   => params["quarter"].try(:to_i) || Time.now.current_quarter
    }
    debugger
    @do_assignments = (1..13).map do |num|
      @hash[:week] = num
      @org.do_assignments.find_or_new(@hash)
    end
  end

  def edit
    @org = Org.where(:name => "BAMRU").first
    @hash = {
            :org_id    => @org.id,
            :year      => params["year"]    || Time.now.year,
            :quarter   => params["quarter"] || Time.now.current_quarter
    }
    @do_assignments = (1..13).map do |num|
      @hash[:week] = num
      @org.do_assignments.find_or_new(@hash)
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
