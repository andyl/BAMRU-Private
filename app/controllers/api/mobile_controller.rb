class Api::MobileController < ApplicationController

  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/api/mobile.json
  def index
    render :layout => false
  end

end
