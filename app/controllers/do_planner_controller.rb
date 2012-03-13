class DoPlannerController < ApplicationController

  before_filter :authenticate_member!

  def index
    @org = Org.where(:name => "BAMRU").first
    @quarter = {
            :year      => params["year"].try(:to_i)    || Time.now.year,
            :quarter   => params["quarter"].try(:to_i) || Time.now.current_quarter
    }
    @current_week    = Time.now.current_week
    @current_quarter = Time.now.current_quarter
    @mem_ids = AvailDo.where(@quarter).map {|x| x.member_id}.uniq.sort
    @members = Member.order(:last_name).find(@mem_ids)
    @do_assignments = (1..13).map do |num|
      quarter = @quarter.clone
      quarter[:org_id] = 1
      quarter[:week] = num
      @org.do_assignments.find_or_new(quarter)
    end
  end

  def update
    directive = params[:directive]
    year, quarter, week, memid = params[:id].split('-')
    case directive
      when 'select'
        options = {year: year, quarter: quarter, week: week}
        assignment = DoAssignment.where(options).try(:first)
        member_name = Member.find(memid).try(:full_name)
        if assignment.blank?
          new_opts = options.merge({primary_id: memid, name: member_name})
          DoAssignment.create(new_opts)
        else
          assignment.update_attributes(primary_id: memid, name: member_name)
        end
      when 'unselect'
        options = {year: year, quarter: quarter, week: week, primary_id: memid}
        assignment = DoAssignment.where(options).try(:first)
        assignment.try(:destroy)
    end
    render :nothing => true
  end

end