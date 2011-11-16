class ChatsController < ApplicationController

  def index
    @chats = Chat.order('created_at DESC').limit(20).reverse
    @what  = Chat.order('great DESC') do
      x = 1
      y = 2
      render :action => "certs/new", :layout => "mobile1"
    end
  end

  def create
    chat_params             = params[:chat]
    chat_params[:member_id] = current_member.id
    @chat                   = Chat.create!(chat_params)
    args = { 'text'       => @chat.text,
             'short_name' => @chat.member.short_name,
             'created_at' => @chat.created_at.strftime("%H:%M") }
    local_cast "/chats/new", args.to_json
    render :json => "OK"
  end

end
