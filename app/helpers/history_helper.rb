module HistoryHelper

  def address(outbound)
    return outbound.email.address if outbound.email
    return outbound.phone.sms_email if outbound.phone
    "<deleted addrecord>"
  end

  def via(outbound)
    return " via phone" if outbound.phone
    return " via email" if outbound.email
    " "
  end

  def created_time(obj)
    obj.created_at.strftime("%y-%m-%d %H:%M:%S")
  end

  def reply_time(obj)
    obj.send_time.strftime("%y-%m-%d %H:%M:%S")
  end

  def bounce(inbound)
    v1 = ""
    v2 = "<span style='background-color: pink; padding-left: 3px; padding-right:3px;'>(bounce)</span>"
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


end
