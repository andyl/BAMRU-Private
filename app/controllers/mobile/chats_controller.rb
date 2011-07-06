class Mobile::ChatsController < ApplicationController

  before_filter :authenticate_mobile_member!

  layout 'mobile'

  def index
    @chats = Chat.all.reverse
  end

  def create
    @chat = Chat.create!(params[:chat])
  end

end
