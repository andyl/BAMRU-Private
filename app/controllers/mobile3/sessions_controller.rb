class Mobile3::SessionsController < ApplicationController

  def new
    @page_name = "Login"
    @msg = ""
    if member = Member.find_by_remember_me_token(cookies[:remember_me_token])
      session[:member_id] = member.id
      ActiveSupport::Notifications.instrument("login.mobile3.cookie", {:member => member})
      cookies[:logged_in] = {:value => "true", :expires => Time.now + 360000}
      redirect_to mobile3_path, :notice => "Welcome back #{member.first_name}"
      return
    end
    render :layout => false
  end
  
  def create
    user_name = params[:user_name].squeeze(' ').strip.gsub('.','_').gsub(' ', '_').downcase if params[:user_name]
    member = Member.find_by_user_name(user_name)
    if member && member.authenticate(params[:password])
      if params["remember_me"] == "1"
        cookies[:logged_in] = {:value => "true", :expires => Time.now + 360000}
        cookies[:remember_me_token] = {:value => member.remember_me_token, :expires => Time.now + 360000}
      else
        cookies[:logged_in] = nil
        cookies[:remember_me_token] = nil
      end
      ActiveSupport::Notifications.instrument("login.mobile3.form", {:member => member})
      member_login(member)
      redirect_to mobile_path
    else
      ActiveSupport::Notifications.instrument("login.mobile3.invalid", {:text => params[:user_name]})
      @msg = "<p style='color: red;'>Bad username or password<p/>"
      render :new, :layout => false
    end
  end

  def destroy
    ActiveSupport::Notifications.instrument("logout.mobile3", {:member => current_member})
    session[:member_id] = nil
    cookies[:logged_in] = nil
    cookies[:remember_me_token] = nil
    redirect_to '/mobile3/login', :notice => "Logged out!"
  end

end
