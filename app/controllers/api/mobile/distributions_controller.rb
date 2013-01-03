class Api::Mobile::DistributionsController < ApplicationController

  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  def index
    render :json => DistributionDecorator.mobile_json(current_member.id), :layout => false
  end

  def update

  end

end
