module PreviewHelper

  def preview_nav
    pp = params["opts"].nil? ? "" : "?opts=#{params['opts']}"
    htm = link_to_unless_current "HTML Mail Preview", "/preview/mail_htm#{pp}"
    txt = link_to_unless_current "Text Mail Preview", "/preview/mail_txt#{pp}"
    sms = link_to_unless_current "SMS Preview", "/preview/sms#{pp}"
    "<div id=preview_nav>#{htm} | #{txt} | #{sms}</div>"
  end

end