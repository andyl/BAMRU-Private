class PasswordController < ApplicationController

  # get /password/forgot - collects email address from user
  def forgot
  end

  # post /password/send_email - validates address and sends reset email
  def send_email
    @member = Email.find_by_address(params[:email]).try(:member)
    if @member.try(:valid?)
      @member.reset_forgot_password_token
      call_rake(:send_password_reset_mail, {:address => params[:email], :url => password_reset_url})
      redirect_to "/password/sending?address=#{params[:email]}"
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
    # TODO: fix the timezone problem
    # TODO: check forgot_password_token_expires_at
    @member = current_member || Member.find_by_forgot_password_token(params['token'])
    if @member
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
