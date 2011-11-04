class Api::Mobile3::MessagesController < ApplicationController

  respond_to :xml, :json

  before_filter :authenticate_member_with_basic_auth!

  def index
    @messages = Message.order('id DESC').limit(15).all
    respond_with(@messages)
  end

  def show
    
  end


end
