class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def show
  end

  def create
    Message.create(params[:message])
    redirect_to messages_path
  end
  
end
