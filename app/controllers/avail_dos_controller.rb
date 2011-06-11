class AvailDosController < ApplicationController
  def index
    @member = Member.where(:id => params['member_id']).first
    @hash = {
            :member_id => @member.id,
            :year      => Time.now.year,
            :quarter   => Time.now.current_quarter
    }
    @avail_set = [1..13].map do |num|
      @hash[:week] = num
      @member.avail_dos.find_or_new(@hash)
    end
  end
end
