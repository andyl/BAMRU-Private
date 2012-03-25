class MessagesController < ApplicationController

  include ActionView::Helpers::TextHelper
  include MessagesHelper

  before_filter :authenticate_member_with_basic_auth!

  def index
    file = "tmp/mail_sync_time.txt"
    @sync_time = File.exist?(file) ? File.read(file) : "NA"
    @messages = Message.order('created_at DESC').limit(40).all
  end

  def show
    file = "tmp/mail_sync_time.txt"
    @client_ip = request.remote_ip
    @sync_time = File.exist?(file) ? File.read(file) : "NA"
    @message = Message.where(:id => params["id"]).first
    @msg = @message
    @dists = @msg.distributions
    @mydist = @dists.where(:member_id => current_member.id).first
    @mydist.mark_as_read(current_member, current_member, "Read via web") if @mydist
  end

  def create
    mesg_params = params[:message]
    dist_params = params[:history]
    rsvp_params = params[:rsvps]

    if error = validate_params(mesg_params, dist_params)
      redirect_to members_path, :alert => "#{error}"
      return
    end

    mesg = Message.generate(mesg_params, dist_params, rsvp_params)

    call_rake("ops:email:pending:send2", {}, "#{timestamp}_2")

    label, minutes = dist_label(mesg)
    as_notify("page.send", {:member => current_member, :text => label})

    wiki_link = "<a href='http://wiki.bamru.net/index.php/Paging_Performance'>here</a>"

    string1 = "Page being sent to #{label}"
    string2 = "It will take at least <span id='mincount'>#{minutes}</span> to deliver all messages."
    string3 = "Learn more about our delivery performance #{wiki_link}"
    redirect_to messages_path, :notice => [string1, string2, string3].join("<br/>")
  end

  def update_rsvp
    dist   = Distribution.find_by_id(params[:rsvpid])
    name   = dist.member.full_name
    value  = params[:value].upcase
    string = "You set the RSVP response for <b>#{name}</b> to <b>#{value}</b>"
    redirect_to "/messages/#{params[:id]}", :notice => string
  end

end