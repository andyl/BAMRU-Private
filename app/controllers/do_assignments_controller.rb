class DoAssignmentsController < ApplicationController
  def index
    @org = Org.where(:name => "BAMRU").first
    @hash = {
            :org_id => @org.id,
            :year      => Time.now.year,
            :quarter   => Time.now.current_quarter
    }
    @do_assignments = (1..13).map do |num|
      @hash[:week] = num
      @org.do_assignments.find_or_new(@hash)
    end
  end

  def edit
    @org = Org.where(:name => "BAMRU").first
    @hash = {
            :org_id    => @org.id,
            :year      => Time.now.year,
            :quarter   => Time.now.current_quarter
    }
    @do_assignments = (1..13).map do |num|
      @hash[:week] = num
      @org.do_assignments.find_or_new(@hash)
    end
  end
end
