module ApplicationHelper
  
  def app_notice
    notice_value = notice
    notice_value.blank? ? "<p/>" : "<p class='notice'>#{notice_value}</p>"
  end

  def app_alert
    alert_value = alert
    alert_value.blank? ? "<p/>" : "<p class='alert'>#{alert_value}</p>"
  end

  def sign_out_link
    "<a href='/members/sign_out'>sign out</a>"
  end

  def sign_up_or_in_link
    sign_in_link = "<a href='/members/sign_in'>sign in</a>"
    sign_up_link = "<a href='/members/sign_up'>sign up</a>"
    sign_in_link + ' | ' + sign_up_link
  end

  def user_nav
    if member_signed_in?
      "welcome <b>#{current_member.first_name}</b> | #{sign_out_link}"
    else
      sign_up_or_in_link
    end
  end

  # ----- Debug Helpers -----

  def params_debug_text
    "<br/><b>#{params["controller"]}##{params["action"]}</b> (params: #{params.inspect})"
  end

  def request_env_debug_text
    "<b>Request.env:</b><br/>#{request.env["HTTP_COOKIE"].inspect}"
  end

  def debug_footer_text
    params_debug_text
  end

end