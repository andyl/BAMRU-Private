class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_ability
    @current_ability ||= Ability.new(current_member)
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "Access Denied."
    redirect_to root_url
  end

  private

  def current_member
    @current_member ||= Member.find(session[:member_id]) if session[:member_id]
  end

  def member_signed_in?
    ! current_member.nil?
  end

  helper_method :current_member
  helper_method :member_signed_in?

  def authenticate_member!
    unless member_signed_in?
      session[:ref] = request.url
      redirect_to login_url, :alert => "You must first log in to access this page"
    end
  end

end
