class HistoryController < ApplicationController

  before_filter :authenticate_member!

  def show
    @distribution      = Distribution.find(params['id'])
    @member            = @distribution.member
    @recipient         = @member
    @message           = @distribution.message
    @mails             = @distribution.all_mails
  end

  def update
    @member       = current_member
    @dist_id      = params['id'].to_i
    @distribution = Distribution.find(@dist_id)
    @distribution.update_attributes!(params[:dist])
    render :nothing => true
  end

end
