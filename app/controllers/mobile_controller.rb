class MobileController < ApplicationController

  before_filter :authenticate_mobile_member!

  layout 'mobile'

  def index
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

  def paging
    @members   = Member.order_by_do_typ_score.active
    @page_name = "Paging"
  end

  def status
    @phone = phone_device?
  end
end