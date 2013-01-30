class Mobile1::MessagesController < ApplicationController

  before_filter :authenticate_mobile_member!

  layout 'mobile1'

  def index
    @page_name = "Message Log"
    @messages = Message.order('id DESC').limit(15)
  end

  def show
    @page_name = "Message Detail"
    @message = Message.find(params[:id])
    @dists   = @message.distributions
    @mydist  = @dists.where(:member_id => current_member.id).first

    if @mydist

      x_hash = {
              :distribution_id => @mydist.id,
              :member_id       => current_member.id,
              :action          => "Read message"
      }

      Journal.create(x_hash) if @mydist.read == false
      @mydist.read = true

      if params['response']
        response = params['response'].capitalize
        if @mydist.rsvp_answer != response
          x_hash[:action] = "Set RSVP to #{response}"
          Journal.create(x_hash)
          @mydist.rsvp_answer = response
        end
      end
      
      @mydist.save
    end
  end

end
