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
    @distribution.update_attributes!(params[:dist])
    Journal.create(:member_id => @member.id, :distribution_id => @distribution.id, :action => "Marked as read")
    render :nothing => true
  end

end
