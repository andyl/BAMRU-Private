class RsvpsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @key = params[:id] || "<none>"
  end

  def valid_response?(response)
    %w(y yes n no t tbd).include?(response.downcase)
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
          x_hash = {
                  :distribution_id => @dist.id,
                  :member_id       => current_member.id,
                  :action          => "Set RSVP to #{response}"
          }
          Journal.create(x_hash)
          if @dist.read == false
            x_hash[:action] = "Marked as read"
            Journal.create(x_hash)
          end
          @dist.rsvp_answer = response
          @dist.read = true
          @dist.save
        end
      end
      @rsvp = @dist.message.rsvp
    end
  end

end
