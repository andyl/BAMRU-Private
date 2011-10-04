class JqmController < ApplicationController

  before_filter :authenticate_mobile_member!

  layout 'jqm'

  def index
    @no_cache = true
    @dists = current_member.distributions.order("id DESC")
    unread = @dists.unread.count
    txt    = unread == 0 ? "" : " (#{unread})"
    @inbox_label = "My Inbox#{txt}"
    @do = Member.where(:current_do => true).first
  end

end