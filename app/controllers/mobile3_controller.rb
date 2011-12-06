class Mobile3Controller < ApplicationController

  before_filter { authenticate_mobile_member! '/mobile/login' }
  
  def index
    SpriteGen.generate_sprite_icons
    @is_ipad  = ipad_device?
    @is_phone = phone_device?
    @sensor   = phone_device? ? "true" : "false"
    @members  = Member.all
    @mem_json = MemberDecorator.mobile_json
    @msg_json = MessageDecorator.mobile_json
    @dst_json = DistributionDecorator.mobile_json(current_member.id)
    @dists = current_member.distributions.limit(15).order("id DESC")
    unread = @dists.unread.count
    txt    = unread == 0 ? "" : " (#{unread})"
    @inbox_label = "My Inbox#{txt}"
    @device   = device
    doa = DoAssignment.current.first
    @do_name = doa.backup.try(:last_name) || doa.primary.last_name
    @do_id   = doa.backup.try(:id)        || doa.primary.id

    render :layout => false
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
    call_rake('ops:email:send_distribution', {:message_id => m.id}) unless ENV['RAILS_ENV'] == 'developmenet'
    redirect_to "/mobile3#messages"
  end

end
