class SessionsController < ApplicationController

  def new
    member = Member.find_by_remember_me_token(cookies[:remember_me_token])
    unless member.nil?
      session[:member_id] = member.id
      ActiveSupport::Notifications.instrument("login.browser.cookie", {:member => member})
      redirect_to (session[:tgt_path] || root_path), :notice => "Welcome back #{member.first_name}"
    end
  end

  def create
    user_name = params[:user_name].squeeze.strip.gsub('.','_').gsub(' ', '_').downcase if params[:user_name]
    member = Member.find_by_user_name(user_name)
    if member && member.authenticate(params[:password])
      if params["remember_me"] == "1"
        cookies[:remember_me_token] = {:value => member.remember_me_token, :expires => Time.now + 360000}
      else
        cookies[:remember_me_token] = nil
      end
      ActiveSupport::Notifications.instrument("login.browser.form", {:member => member})
      member_login(member)
      redirect_to (session[:tgt_path] || root_path), :notice => "Logged in!"
    else
      ActiveSupport::Notifications.instrument("login.browser.invalid", {:text => params[:user_name]})
      flash.now.alert = "Invalid user name or password"
      render "new"
    end
  end

  def destroy
    ActiveSupport::Notifications.instrument("logout.browser", {:member => current_member})
    session[:member_id] = nil
    cookies[:remember_me_token] = nil
    redirect_to root_path, :notice => "Logged out!"
  end

end
