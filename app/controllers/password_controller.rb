class PasswordController < ApplicationController

  # get /password/forgot - collects email address from user
  def forgot
  end

  # post /password/send_email - validates address and sends reset email
  def send_email
    @member = Email.find_by_address(params[:email]).try(:member)
    if @member.try(:valid?)
      @member.reset_forgot_password_token
      call_rake(:send_password_reset_mail, :address => params[:email])
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
    @member = Member.where(:forgot_password_token => params['token'])
    # TODO: fix the timezone problem
    # TODO: check forgot_password_token_expires_at
    unless @member
      flash.now.alert = "Unrecognized password (#{params[:email]}).  Please try again."
      render "forgot"
    end
  end

  # post /password/update - processes the password form
  def update
    # process the password
    # if successful, show a flash notice, and redirect to the home page
    # otherwise, show and error message and go back to the reset page
  end

  # get /password/try_again - info message for the user if the reset token is invalid
  def try_again
  end


end
