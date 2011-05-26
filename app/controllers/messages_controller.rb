class MessagesController < ApplicationController
  def index
    @messages = Message.order('created_at DESC').all
  end

  def show
    @message = Message.where(:id => params["id"]).first
  end

  def create
    np = params[:message]
    np[:distributions_attributes] =
            Message.distributions_params(params[:distributions])
    debugger
    Message.create(np)
    redirect_to messages_path
  end
  
end
