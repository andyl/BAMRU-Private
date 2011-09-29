class Mobile::MessagesController < ApplicationController

  before_filter :authenticate_mobile_member!

  layout 'mobile'

  def index
    @page_name = "Message Log"
    @messages = Message.order('id DESC').limit(15)
  end

  def show
    @page_name = "Message Detail"
    @message = Message.find(params[:id])
    @dists   = @message.distributions
    @mydist  = @dists.where(:member_id => current_member.id).first
    if @mydist && params['response']
      response = params['response'].capitalize
      if @mydist.rsvp_answer != response
        x_hash = {
                :distribution_id => @mydist.id,
                :member_id       => current_member.id,
                :action          => "Set RSVP to #{response}"
        }
        if @mydist.read == false
          x_hash[:action] = "Marked as read"
          Journal.create(x_hash)
          x_hash[:action] = "Set RSVP to #{response}"
        end
        Journal.create(x_hash)
        @mydist.rsvp_answer = response
        @mydist.read = true
        @mydist.save
      end
    end
  end

end
