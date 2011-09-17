class RsvpsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @key = params[:id] || "<none>"
  end

  def valid_response?(response)
    %w(y yes n no t tbd).include?(response.downcase)
  end

  def show
    @key = params[:id] || "<none>"
    @dist = Distribution.where(:id => @key).first
    @member = @dist.member
    unless @dist.blank?
      if params[:response] && valid_response?(params[:response])
        Journal.create(:distribution_id => @dist.id, :member_id => current_member.id, :action => "Set RSVP to #{params[:response].capitalize}" )
        @dist.rsvp_answer = params[:response].capitalize
        @dist.read = true
        @dist.save
      end
      @rsvp = @dist.message.rsvp
    end
  end

end
