class Mobile3Controller < ApplicationController

  before_filter :authenticate_mobile_member!
  
  def index
    @ipad_device = ipad_device?
    @mem_json = MemberDecorator.mobile_json
    @msg_json = MessageDecorator.mobile_json
    @dst_json = DistributionDecorator.mobile_json(current_member.id)
    @dists = current_member.distributions.limit(15).order("id DESC")
    unread = @dists.unread.count
    txt    = unread == 0 ? "" : " (#{unread})"
    @inbox_label = "My Inbox#{txt}"
    @is_phone = phone_device?
    @do_name = DoAssignment.current.first.primary.last_name
    @do_id   = DoAssignment.current.first.primary.id

    render :layout => false
  end

  #def login
  #  @page_name = "Login"
  #  if member = Member.find_by_remember_me_token(cookies[:remember_me_token])
  #    session[:member_id] = member.id
  #    redirect_to (session[:ref] || mobile1_path), :notice => "Welcome back #{member.first_name}"
  #  end
  #end
  #
  #def create_session
  #  params[:user_name] = params[:user_name].gsub('.','_').downcase if params[:user_name]
  #  member = Member.find_by_user_name(params[:user_name])
  #  if member && member.authenticate(params[:password])
  #    if params["remember_me"] == "1"
  #      cookies[:remember_me_token] = {:value => member.remember_me_token, :expires => Time.now + 360000}
  #    else
  #      cookies[:remember_me_token] = nil
  #    end
  #    member_login(member)
  #    redirect_to (session[:ref] || params[:ref] || mobile1_path)
  #  else
  #    render :new
  #  end
  #end
  #
  #def destroy_session
  #  session[:member_id] = nil
  #  cookies[:remember_me_token] = nil
  #  redirect_to mobile1_path, :notice => "Logged out!"
  #end

  
end
