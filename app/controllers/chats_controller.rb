class ChatsController < ApplicationController

  def index
    @chats = Chat.all.reverse
  end

  def create
    @chat = Chat.create!(params[:chat])
  end

end
