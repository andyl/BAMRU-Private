class Mobile2::MessagesController < ApplicationController

  respond_to :html, :json

  before_filter :authenticate_mobile_member!

  def index
    render :text => MessageDecorator.mobile_json,
           :content_type => "application/json",
           :layout => false
  end

  def show
    id  = params[:id]
    msg = Message.find(id)
    render :text => MessageDecorator.new(msg).mobile_json,
           :content_type => "application/json"
  end

end
