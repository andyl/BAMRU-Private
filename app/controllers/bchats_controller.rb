class BchatsController < ApplicationController

  def index
    @bchat_json = BchatDecorator.mobile_json
  end

  def create
    chat_params = params[:chat]
    chat_params[:member_id] = current_member.id
    @chat = Chat.create!(chat_params)
  end

end
