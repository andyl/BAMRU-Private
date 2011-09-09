class HomeController < ApplicationController

  before_filter :authenticate_member!, :except => [:contact, :tbd, :about]

  def index
  end

  def test
  end

  def tbd
  end

  def contact
  end

  def mobile
  end

  def edit_info
  end

  def wiki
  end

  def mail_sync
    call_rake("email:import")
  end

  def silent_mail_sync
    call_rake("email:import")
    render :nothing => true
  end

end
