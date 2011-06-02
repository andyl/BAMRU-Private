class DoAssignmentsController < ApplicationController
  def index
    @do_assignments = DoAssignment.order('year ASC')
  end

  def show

  end
end
