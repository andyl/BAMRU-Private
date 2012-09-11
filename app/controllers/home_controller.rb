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

  def labs
    ActiveSupport::Notifications.instrument("service.labs", {:member => current_member})
  end

  def edit_info
  end

  def wiki
    path = params[:wiki_path] || ""
    path = path.split('?').first unless path.blank?
    mw_file = "/home/aleak/.mw_auth/#{current_member.wiki_name}"
    ActiveSupport::Notifications.instrument("service.wiki", {:member => current_member})
    system "ssh aleak@wiki.bamru.net 'touch #{mw_file}'"
    @link = "http://wiki.bamru.net#{path}?username=#{current_member.wiki_name}"
    redirect_to @link
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

  def readstats
    ids = Member.all.map {|mem| mem.id}
    @mem_hsh = Distribution.where(read:false).all.reduce({}) do |acc, dist|
            id = dist.member_id
            acc[id] = acc[id] ? acc[id] += 1 : 1 if ids.include?(id)
            acc
    end
    @mem_arr = @mem_hsh.to_a.sort_by {|x| x.last}.reverse
    @mem_cnt = @mem_hsh.keys.reduce({}) do |acc, memid|
      acc[memid] = Distribution.where(member_id: memid).count
      acc
    end
    @mem_pct = @mem_cnt.keys.reduce({}) do |acc, memid|
      acc[memid] = (@mem_hsh[memid] * 100) / @mem_cnt[memid]
      acc
    end
    @members = Member.find(@mem_arr.map {|x| x.first})
  end

  def browserstats
    @profiles = BrowserProfile.all
  end


end
