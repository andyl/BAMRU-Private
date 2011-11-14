class Api::BchatController < ApplicationController

  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/api/bchat.json
  def index
    render :layout => false
  end

end
