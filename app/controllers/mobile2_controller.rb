class Mobile2Controller < ApplicationController

  before_filter :authenticate_mobile_member!

  layout 'mobile2'

  def index
    @mem_json = MemberDecorator.mobile_json
    @msg_json = MessageDecorator.mobile_json
    @no_cache = true
    @is_phone = phone_device?
    @dists = current_member.distributions.order("id DESC")
    unread = @dists.unread.count
    txt    = unread == 0 ? "" : " (#{unread})"
    @inbox_label = "My Inbox#{txt}"
    @do_name = DoAssignment.current.first.primary.last_name
    @do_id   = DoAssignment.current.first.primary.id
  end

end