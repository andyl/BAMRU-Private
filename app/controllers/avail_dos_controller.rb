class AvailDosController < ApplicationController
  def index
    @member = Member.where(:id => params['member_id']).first
  end
end
