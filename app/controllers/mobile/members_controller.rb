class Mobile::MembersController < ApplicationController

  before_filter :authenticate_mobile_member!

  layout 'mobile'

  def index
    @page_name = "Roster"
    @members = Member.order_by_last_name.all
  end

  def show
    @phone = phone_device?
    @member = Member.where(:id => params[:id]).first
  end

end
