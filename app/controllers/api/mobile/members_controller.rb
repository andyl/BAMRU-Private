class Api::Mobile::MembersController < ApplicationController

  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  def index
    render :json => MemberDecorator.mobile_json(Member.order_by_last_name.all), :layout => false
  end

  def show
    
  end

end
