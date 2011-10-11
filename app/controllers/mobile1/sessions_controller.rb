class Mobile1::SessionsController < ApplicationController

  layout 'mobile1'

  def new
    @page_name = "Login"
    if member = Member.find_by_remember_me_token(cookies[:remember_me_token])
      session[:member_id] = member.id
      redirect_to (session[:ref] || mobile1_path), :notice => "Welcome back #{member.first_name}"
    end
  end
  
  def create
    params[:user_name] = params[:user_name].gsub('.','_').downcase if params[:user_name]
    member = Member.find_by_user_name(params[:user_name])
    if member && member.authenticate(params[:password])
      if params["remember_me"] == "1"
        cookies[:remember_me_token] = {:value => member.remember_me_token, :expires => Time.now + 360000}
      else
        cookies[:remember_me_token] = nil
      end
      member_login(member)
      redirect_to (session[:ref] || params[:ref] || mobile1_path)
    else
      render new
    end
  end

  def destroy
    session[:member_id] = nil
    cookies[:remember_me_token] = nil
    redirect_to mobile1_path, :notice => "Logged out!"
  end

end
