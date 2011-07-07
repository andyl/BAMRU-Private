class Mobile::ChatsController < ApplicationController

  before_filter :authenticate_mobile_member!

  layout 'mobile'

  def index
    @chats = Chat.order('created_at DESC').limit(35).reverse
  end

  def create
    chat_params = params[:chat]
    chat_params[:member_id] = current_member.id
    @chat = Chat.create!(chat_params)
  end

end
