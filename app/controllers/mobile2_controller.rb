class Mobile2Controller < ApplicationController

  before_filter :authenticate_mobile_member!

  layout 'mobile2'

  def index
    @no_cache = true
    @members  = Member.all
    @phone = phone_device?
    @dists = current_member.distributions.order("id DESC")
    unread = @dists.unread.count
    txt    = unread == 0 ? "" : " (#{unread})"
    @inbox_label = "My Inbox#{txt}"
    @do = Member.where(:current_do => true).first
  end

end