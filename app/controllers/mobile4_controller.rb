class Mobile4Controller < ApplicationController

  before_filter :authenticate_mobile_member!
  
  def index
    @is_ipad  = ipad_device?
    @is_phone = phone_device?
    @sensor   = phone_device? ? "true" : "false"
    @mem_json = MemberDecorator.mobile_json
    @msg_json = MessageDecorator.mobile_json
    @dst_json = DistributionDecorator.mobile_json(current_member.id)
    @dists = current_member.distributions.limit(15).order("id DESC")
    unread = @dists.unread.count
    txt    = unread == 0 ? "" : " (#{unread})"
    @inbox_label = "My Inbox#{txt}"
    @device   = device
    @do_name = DoAssignment.current.first.primary.last_name
    @do_id   = DoAssignment.current.first.primary.id

    render :layout => false
  end

end
