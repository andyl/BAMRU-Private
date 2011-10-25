class Api::DoController < ApplicationController

  respond_to :xml, :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/api/do/set_do.json
  def set_do
    Member.set_do
    render :json => "OK\n"
  end

end
