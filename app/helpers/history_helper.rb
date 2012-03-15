module HistoryHelper

  def history_address(outbound)
    if outbound.email.blank? && outbound.phone.blank?
      return "<del>#{outbound.address}</del> (deleted)"
    end
    return "<del>#{outbound.address}</del> (changed)" if outbound.changed?
    return "<del>#{outbound.address}</del> (disabled)" if outbound.disabled?
    outbound.address
  end

  def via(outbound)
    return " via phone" if outbound.phone
    return " via email" if outbound.email
    " "
  end

  def sent_time(obj)
    obj.sent_at.nil? ? "PENDING" : obj.sent_at.strftime("%y-%m-%d %H:%M:%S")
  end

  def created_time(obj)
    obj.created_at.strftime("%y-%m-%d %H:%M:%S")
  end

  def reply_time(obj)
    obj.send_time.strftime("%y-%m-%d %H:%M:%S")
  end

  def reply_txt(inbound)
    color = case
      when inbound.fixed?   then "#ccffff"
      when inbound.bounced? then "pink"
      else "white"
    end
    e_link = "<a href='/members/#{@recipient.id}/edit'>Edit</a>"
    i_link = "<a href='#' class='ignore_link' id='i_#{inbound.id}'>Ignore</a>"
    d_link = "<a href='#' class='disable_link' id='d_#{inbound.id}'>Disable</a>"
    action = " (#{i_link} | #{d_link} | #{e_link})"
    f_link = current_member == @recipient || current_member.admin? ? action : " Needs Fixing"
    lbl    = inbound.fixed? ? "(Fixed)" : f_link
    lbl    = "(Ignored)" if inbound.ignore_bounce?
    v1 = "Reply "
    v2 = "<span style='background-color: #{color}; padding-left: 3px; padding-right:3px;'>Bounce #{lbl}</span>"
    inbound.bounced? ? v2 : v1
  end

  def view(inbound)
    "<a href='#' class=click_view id='#{inbound.id}_view'>view</a>"
  end

  def hide(inbound)
    "<a href='#' class=click_hide id='#{inbound.id}_hide'>hide</a>"
  end

  def body(inbound)
    text = inbound.body.gsub("\n", "<br/>")
  end

  def rsvp_history_display(distribution)
    return "NA" unless distribution.rsvp
    ans = distribution.rsvp_answer
    ans.blank? ? "PENDING" : ans
  end

  def rsvp_link_helper(distribution)
    return "" unless distribution.rsvp
    yes_link = "<a href='#' id='Yes_#{distribution.id}' class=rsvp_yn>Change to YES</a>"
    no_link = "<a href='#' id='No_#{distribution.id}' class=rsvp_yn>Change to NO</a>"
    return "(#{no_link})" if distribution.rsvp_answer == "Yes"
    return "(#{yes_link})" if distribution.rsvp_answer == "No"
    "(#{yes_link} | #{no_link})"
  end

end
