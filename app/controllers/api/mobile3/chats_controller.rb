class Api::Mobile3::ChatsController < ApplicationController

  respond_to :xml, :json

  before_filter :authenticate_member_with_basic_auth!

  def index
    render :json => MessageDecorator.mobile_json, :layout => false
  end

  def show
    
  end

end
