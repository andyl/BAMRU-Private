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

  def local_cast(channel, string)
    message = {:channel => channel, :data => string}
    uri = URI.parse("#{FAYE_SERVER}/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "Access Denied."
    redirect_to root_url
  end

  def call_rake(task, options = {})
    options[:rails_env] ||= Rails.env
    args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
    cmd = "/usr/bin/rake #{task} #{args.join(' ')} --trace"
    nq(cmd)
  end

  def nq(cmd)
    system "(cd #{Rails.root}; script/nq #{cmd}) >> #{Rails.root}/log/nq.log 2>&1 &"
  end

  def device
    agent = env["HTTP_USER_AGENT"]
    case agent
      when /Kindle/      then "Kindle"
      when /Android/     then "Android"
      when /iPod/        then "iPod"
      when /iPhone/      then "iPhone"
      when /iPad/        then "iPad"
      when /BlackBerry/  then "BlackBerry"
      when /MSIE/        then "IE"
      when /Silk/        then "Silk"
      when /Firefox/     then "Firefox"
      when /Konqueror/   then "Konqueror"
      when /Netscape/    then "Netscape"
      when /Opera/       then "Opera"
      when /Chrome/      then "Chrome"
      when /Safari/      then "Safari"
      else  "Unknown"
    end
  end

  def ipad_device?
    device == "iPad"
  end

  def phone_device?
    return true if device == "Chrome" && ENV['RAILS_ENV'] == "development"
    %w(Android iPhone BlackBerry).include? device
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

  # can be called with curl using http_basic authentication
  # curl -u user_name:pass http://bamru.net/reports
  # curl -u user_name:pass http://bamru.net/reports/BAMRU-report.csv
  #    note: user_name should be in the form of user_name, not user.name
  def authenticate_member_with_basic_auth!
    if member = authenticate_with_http_basic { |u,p| Member.find_by_user_name(u).authenticate(p) }
      session[:member_id] = member.id
    else
      authenticate_member!
    end
  end


  def authenticate_member!
    unless member_signed_in?
      session[:tgt_path]  = request.url
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
