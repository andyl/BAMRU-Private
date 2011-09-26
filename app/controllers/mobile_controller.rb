class MobileController < ApplicationController

  before_filter :authenticate_mobile_member!

  layout 'mobile'

  def index
  end

  def index_old
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
    @page_name = "Inbox"
  end

  def paging
    @members   = Member.active.all
    @page_name = "Paging"
  end

  def status
    #@phone = phone_device?
    @phone = true
  end
end