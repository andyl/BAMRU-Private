class Mobile2Controller < ApplicationController

  before_filter :authenticate_mobile_member!

  layout 'mobile2'

  def index
    @mem_json = MemberDecorator.mobile_json
    @no_cache = true
    @members  = Member.active.all
    @phone = phone_device?
    @dists = current_member.distributions.order("id DESC")
    unread = @dists.unread.count
    txt    = unread == 0 ? "" : " (#{unread})"
    @inbox_label = "My Inbox#{txt}"
    @do = Member.where(:current_do => true).first
  end

  def members
    render :text => MemberDecorator.mobile_json,
           :content_type => "application/json",
           :layout => false
  end

  def messages
    render :text => "HELLO MESSAGES",
           :content_type => "application/json",
           :layout => false
  end

end