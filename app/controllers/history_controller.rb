class HistoryController < ApplicationController

  before_filter :authenticate_member!

  def show
    @distribution      = Distribution.find(params['id'])
    @member            = @distribution.member
    @recipient         = @member
    @message           = @distribution.message
    @mails             = @distribution.all_mails
    @journals          = @distribution.journals
  end

  def update
    @member       = current_member
    @dist_id      = params['id'].to_i
    @distribution = Distribution.find(@dist_id)
    if @distribution.read == false && params['dist']['read'] == 'true'
      Journal.create(:member_id => @member.id, :distribution_id => @distribution.id, :action => "Marked as read")
    end
    if params['dist']['rsvp_answer']
      params['dist']['read'] = 'true'
      Journal.create(:member_id => @member.id, :distribution_id => @dist_id, :action => "Set RSVP to #{params['dist']['rsvp_answer']}")
      if @distribution.read == false
        Journal.create(:member_id => @member.id, :distribution_id => @distribution.id, :action => "Marked as read")
      end
    end
    @distribution.update_attributes!(params[:dist])
    render :nothing => true
  end

  def markall
    @member = current_member
    @member.distributions.unread.all.each do |d|
      d.read = true
      d.save
      Journal.create(:member_id => @member.id, :distribution_id => d.id, :action => "Marked as read")
    end
    render :nothing => true
  end

end
