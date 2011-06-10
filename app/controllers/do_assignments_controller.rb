class DoAssignmentsController < ApplicationController
  def index
    @do_assignments = DoAssignment.order('year ASC').where(:quarter => Time.now.current_quarter).where(:year => Time.now.year)
  end

  def show

  end
end
