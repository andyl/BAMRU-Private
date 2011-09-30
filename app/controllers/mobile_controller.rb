class MobileController < ApplicationController

  before_filter :authenticate_mobile_member!

  layout 'mobile'

  def index
    @dists = current_member.distributions.order("id DESC")
    unread = @dists.unread.count
    txt    = unread == 0 ? "" : " (#{unread})"
    @inbox_label = "My Inbox#{txt}"
    @do = Member.where(:current_do => true).first
  end

  def about
  end

  def tbd
  end

  def contact
  end

  def map
  end

  def inbox
    @dists = current_member.distributions.order("id DESC")
    unread = @dists.unread.count
    txt    = unread == 0 ? "" : " (#{unread})"
    @page_name = "Inbox#{txt}"
  end

  def status
    @phone = phone_device?
  end

  def paging
    @client_ip = request.remote_ip
    @members   = Member.order_by_do_typ_score.active
    @page_name = "Paging"
  end

  def send_page
    np = params[:message]
    np[:author_id] = current_member.id
    if params[:targets].blank?
      redirect_to members_path, :alert => "No addresses selected - Please try again."
      return
    end
    if np[:text].blank?
      redirect_to members_path, :alert => "Empty message text - Please try again"
      return
    end
    np[:distributions_attributes] = Message.mobile_distributions_params(params[:targets])
    m = Message.create(np)
    unless params['rsvp_select'].blank?
      opts = JSON.parse(params['rsvp_select'])
      opts[:message_id] = m.id
      p = Rsvp.create(opts)
    end
    call_rake('email:send_distribution', {:message_id => m.id})
    redirect_to "/mobile/messages"
  end

end