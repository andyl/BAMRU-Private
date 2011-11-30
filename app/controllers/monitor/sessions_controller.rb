class Monitor::SessionsController < ApplicationController

  def new
    @page_name = "Login"
    @msg = ""
    if member = Member.find_by_remember_me_token(cookies[:remember_me_token])
      session[:member_id] = member.id
      ActiveSupport::Notifications.instrument("login.monitor.cookie", {:member => member})
      cookies[:logged_in] = {:value => "true", :expires => Time.now + 360000}
      redirect_to monitor_path, :notice => "Welcome back #{member.first_name}"
      return
    end
    render :layout => false
  end
  
  def create
    user_name = params[:user_name].squeeze.strip.gsub('.','_').gsub(' ', '_').downcase if params[:user_name]
    member = Member.find_by_user_name(user_name)
    if member && member.authenticate(params[:password])
      if params["remember_me"] == "1"
        cookies[:logged_in] = {:value => "true", :expires => Time.now + 360000}
        cookies[:remember_me_token] = {:value => member.remember_me_token, :expires => Time.now + 360000}
      else
        cookies[:logged_in] = nil
        cookies[:remember_me_token] = nil
      end
      ActiveSupport::Notifications.instrument("login.monitor.form", {:member => member})
      member_login(member)
      redirect_to monitor_path
    else
      ActiveSupport::Notifications.instrument("login.monitor.invalid", {:text => params[:user_name]})
      @msg = "<p style='color: red;'>Bad username or password<p/>"
      render :new, :layout => false
    end
  end

  def destroy
    ActiveSupport::Notifications.instrument("logout.monitor", {:member => current_member})
    session[:member_id] = nil
    cookies[:logged_in] = nil
    cookies[:remember_me_token] = nil
    redirect_to '/monitor/login', :notice => "Logged out!"
  end

end
