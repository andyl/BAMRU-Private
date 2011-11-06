class Mobile3Controller < ApplicationController

  def index

    @mem_json = MemberDecorator.mobile_json
    @msg_json = MessageDecorator.mobile_json
    @dists = current_member.distributions.order("id DESC")
    unread = @dists.unread.count
    txt    = unread == 0 ? "" : " (#{unread})"
    @is_phone = phone_device?
    @inbox_label = "My Inbox#{txt}"
    @do_name = DoAssignment.current.first.primary.last_name
    @do_id   = DoAssignment.current.first.primary.id

    render :layout => false
  end
  
end
