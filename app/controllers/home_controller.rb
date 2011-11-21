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
    path = params[:wiki_path] || ""
    mw_file = "/home/aleak/.wm_auth/#{current_member.wiki_name}"
    system "scp wiki.bamru.net 'touch #{mw_file}'"
    sleep 0.25
    @link = "http://wiki.bamru.net#{path}?username=#{current_member.wiki_name}"
  end

  def mail_sync
    call_rake("ops:email:import")
  end

  def silent_mail_sync
    call_rake("ops:email:import")
    render :nothing => true
  end

  def preview
    @response = params[:response]
  end

  def testrake
    call_rake("ops:raketest")
  end


end
