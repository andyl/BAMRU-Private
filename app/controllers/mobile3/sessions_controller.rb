class Mobile3::SessionsController < ApplicationController

  def new
    @page_name = "Login"
    if member = Member.find_by_remember_me_token(cookies[:remember_me_token])
      session[:member_id] = member.id
      cookies[:logged_in] = {:value => "true", :expires => Time.now + 360000}
      redirect_to mobile3_path, :notice => "Welcome back #{member.first_name}"
      return
    end
    render :layout => false
  end
  
  def create
    params[:user_name] = params[:user_name].gsub('.','_').downcase if params[:user_name]
    member = Member.find_by_user_name(params[:user_name])
    if member && member.authenticate(params[:password])
      if params["remember_me"] == "1"
        cookies[:logged_in] = {:value => "true", :expires => Time.now + 360000}
        cookies[:remember_me_token] = {:value => member.remember_me_token, :expires => Time.now + 360000}
      else
        cookies[:logged_in] = nil
        cookies[:remember_me_token] = nil
      end
      member_login(member)
      redirect_to mobile3_path
    else
      render :new, :layout => false
    end
  end

  def destroy
    session[:member_id] = nil
    cookies[:logged_in] = nil
    cookies[:remember_me_token] = nil
    redirect_to mobile_login_path, :notice => "Logged out!"
  end

end
