class Api::Mobile3Controller < ApplicationController

  respond_to :xml, :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/api/mobile3.json
  def index
    render :layout => false
  end

end
