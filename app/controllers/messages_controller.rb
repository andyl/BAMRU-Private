class MessagesController < ApplicationController

  before_filter :authenticate_member!

  def index
    file = "tmp/mail_sync_time.txt"
    @sync_time = File.exist?(file) ? File.read(file) : "NA"
    @messages = Message.order('created_at DESC').all
  end

  def show
    @message = Message.where(:id => params["id"]).first
    @msg = @message
  end

  def create
    puts params.inspect
    np = params[:message]
    if params[:history].blank?
      redirect_to members_path, :alert => "No addresses selected - Please try again."
      return
    end
    if params[:message][:text].blank?
      redirect_to members_path, :alert => "Empty message text - Please try again"
      return
    end
    np[:distributions_attributes] = Message.distributions_params(params[:history])
    m = Message.create(np)
    if params['rsvps']
      opts = JSON.parse(params['rsvps'])
      opts[:message_id] = m.id
      p = Rsvp.create(opts)
    end
    call_rake('email:send_distribution', {:message_id => m.id})
    redirect_to messages_path, :notice => "Message sent."
  end
  
end
