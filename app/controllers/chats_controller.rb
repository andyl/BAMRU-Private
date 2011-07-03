class ChatsController < ApplicationController

  def index
    @chats = Chat.all
  end

  def create
    @chat = Chat.create!(params[:chat])
  end

end
