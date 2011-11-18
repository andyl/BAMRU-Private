class PasswordController < ApplicationController

  # get /password/forgot - collects email address from user
  def forgot
  end

  # post /password/send_email - validates address and sends reset email
  def send_email
    @email  = Email.where("lower(address) like ?", params[:email]).try(:first)
    @member = @email.try(:member)
    if @member.try(:valid?)
      address = @email.address
      call_rake('ops:email:generate:password_reset', {:address => address})
      call_rake('ops:email:pending:send')
      auth = Member.find_or_create_by_user_name "public_user"
      text = "Forgot Password mail (#{@member.last_name} - #{address})"
      hash = {:ip_address => request.remote_ip, :author => auth, :recipients => [@member], :text => text}
      hash[:format] = 'forgot_password'
      Message.create(hash)
      redirect_to "/password/sending?address=#{address}"
    else
      flash.now.alert = "Unrecognized email address (#{params[:email]}).  Please try again."
      render "forgot"
    end
  end

  # get /password/sending - message for the user after the email has been sent
  def sending
    @address = params[:address]
  end

  # get /password/reset?token=qwerqwerasdfd - this link is embedded in the email
  # if the token is valid, the user must create a new password
  def reset
    Time.zone = "Pacific Time (US & Canada)"
    unless current_member.nil?
      redirect_to root_path, :notice => "You are already logged in!"
      return
    end
    @member = Member.find_by_forgot_password_token(params['token'])
    if @member && (@member.forgot_password_expires_at > Time.now)
      @member.clear_forgot_password_token
      member_login(@member) unless member_signed_in?
      @member.password = ""
      authorize! :manage, @member
    else
      flash.now.alert = "Your password reset token has been used or expired.  Please try again."
      render "forgot"
    end
  end

  # post /password/update - processes the password form
  def update
    @member = Member.find_by_id(params[:member][:id])
    authorize! :manage, @member
    m_params = params["member"]
    x = @member.update_attributes(m_params)
    if x
      redirect_to root_path, :notice => "Successful Password Reset"
    else
      render "reset"
    end
  end

end
