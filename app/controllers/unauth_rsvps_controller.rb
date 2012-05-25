class UnauthRsvpsController < ApplicationController

  # WARNING: Users are NOT required to log in before accessing this.

  def show
    @token  = params[:id] || "<none>"
    @dist = Distribution.where(:unauth_rsvp_token => @token).first
    @member  = @dist.member
    unless @dist.blank?
      response = params[:response].try(:capitalize)
      render "expired" unless valid_token?(@token)
      if response && valid_response?(response)
        flash[:notice] = "You set the RSVP response to '#{response}'"
        if @dist.rsvp_answer != response
          @dist.set_rsvp(@member, @member, response)
        end
      end
      @rsvp = @dist.message.rsvp
    end
  end

  private

  def valid_response?(response)
    %w(y yes n no).include?(response.downcase)
  end

  def valid_token?(token)
    @dist.unauth_rsvp_expires_at > Time.now
  end
end
