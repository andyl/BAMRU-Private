class RsvpsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @key = params[:id] || "<none>"
  end

  def show
    @key  = params[:id] || "<none>"
    @dist = Distribution.where(:id => @key).first
    @member  = @dist.member
    @message = @dist.message
    unless @dist.blank?
      response = params[:response].try(:capitalize)
      if response && valid_response?(response)
        flash[:notice] = "You set the RSVP response to '#{response}'"
        if @dist.rsvp_answer != response
          @dist.set_rsvp_answer(current_member, response)
        end
      end
      @rsvp = @dist.message.rsvp
    end
  end

  private

  def valid_response?(response)
    %w(y yes n no).include?(response.downcase)
  end

end
