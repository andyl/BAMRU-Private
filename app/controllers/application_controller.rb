class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_time_zone

  def set_time_zone
    Time.zone = "Pacific Time (US & Canada)"
  end

  def current_ability
    @current_ability ||= Ability.new(current_member)
  end

  def member_login(member)
    session[:member_id] = member.id
    new_member = Member.where(:id => member.id).first
    new_member.sign_in_count   += 1
    new_member.last_sign_in_at = Time.now
    new_member.ip_address      = request.remote_ip
    new_member.password = ""
    new_member.password_confirmation = ""
    new_member.save
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "Access Denied."
    redirect_to root_url
  end

  def call_rake(task, options = {})
    options[:rails_env] ||= Rails.env
    args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
    system "/usr/bin/rake #{task} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/rake.log &"
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

  def authenticate_mobile_member!
    unless member_signed_in?
      session[:ref] = request.url
      redirect_to mobile_login_url, :alert => "You must first log in to access this page"
    end
  end

end
