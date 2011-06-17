class SessionsController < ApplicationController

  def new
  end
  
  def create
    member = Member.find_by_user_name(params[:user_name])
    if member && member.authenticate(params[:password])
      session[:member_id] = member.id
      debugger
      redirect_to (session[:ref] || root_path), :notice => "Logged in!"
#      redirect_to :back, :notice => "Logged in!"
#      redirect_to request.referer, :notice => "Logged in!"
#      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:member_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end
