class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_ability
    @current_ability ||= Ability.new(current_member)
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "Access Denied."
    redirect_to root_url
  end
  
end
