class MessagesController < ApplicationController

 include ActionView::Helpers::TextHelper

 before_filter :authenticate_member_with_basic_auth!

  def index
    puts '>'
    puts "SDF"
    file = "tmp/mail_sync_time.txt"
    @sync_time = File.exist?(file) ? File.read(file) : "NA"
    @messages = Message.order('created_at DESC').limit(30).all
  end

  def show
    file = "tmp/mail_sync_time.txt"
    @sync_time = File.exist?(file) ? File.read(file) : "NA"
    @message = Message.where(:id => params["id"]).first
    @msg = @message
    @dists = @msg.distributions
    @mydist = @dists.where(:member_id => current_member.id).first
    if @mydist
      x_hash = {
              :distribution_id => @mydist.id,
              :member_id       => current_member.id,
              :action          => "Read via web"
      }
      Journal.create(x_hash) if @mydist.read == false
      @mydist.read = true
      @mydist.save
    end
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
    np[:format] = 'page'
    m = Message.create(np)
    if params['rsvps']
      opts = JSON.parse(params['rsvps'])
      opts[:message_id] = m.id
      p = Rsvp.create(opts)
    end
    m.create_all_outbound_mails
    member_count    = m.distributions.count
    outbound_count  = m.outbound_mails.count
    dst = "#{pluralize(member_count, "member")} / #{pluralize(outbound_count, "address")}"
    link   = "(<a target='_blank' href='/monitor'>monitor</a>)"
    link   = ""
    notice = "Message being sent to #{dst} #{link}"
    timestamp = Time.now.strftime("%y%m%d_%H%M%S")
    call_rake("ops:email:pending:send2",           {}, "#{timestamp}_2")
    ActiveSupport::Notifications.instrument("page.send", {:member => current_member, :text => dst})
    redirect_to messages_path, :notice => notice
  end
  
end
