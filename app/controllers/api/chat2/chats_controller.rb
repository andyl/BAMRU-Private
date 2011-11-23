class Api::Chat2::ChatsController < ApplicationController

  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  def index
    render :json => Chat2Decorator.mobile_json, :layout => false
  end

  def show
    
  end

end
