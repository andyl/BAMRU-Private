class Mobile::SessionsController < ApplicationController

  layout 'mobile'

  def new
    if member = Member.find_by_password_digest(cookies[:digest])
      session[:member_id] = member.id
      redirect_to (session[:ref] || mobile_path), :notice => "Welcome back #{member.first_name}"
    end
  end
  
  def create
    params[:user_name] = params[:user_name].gsub('.','_').downcase if params[:user_name]
    member = Member.find_by_user_name(params[:user_name])
    if member && member.authenticate(params[:password])
      session[:member_id] = member.id
      if params["remember_me"] == "1"
        cookies[:digest] = {:value => member.password_digest, :expires => Time.now + 360000}
      else
        cookies[:digest] = nil
      end
      member.sign_in_count   += 1
      member.last_sign_in_at = Time.now
      member.save
      redirect_to (session[:ref] || mobile_path), :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:member_id] = nil
    cookies[:digest] = nil
    redirect_to mobile_path, :notice => "Logged out!"
  end

end
