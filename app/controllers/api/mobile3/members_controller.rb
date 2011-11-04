class Api::Mobile3::MembersController < ApplicationController

  respond_to :xml, :json

  before_filter :authenticate_member_with_basic_auth!

  def index
    @members = Member.all
    respond_with(@members)
  end

  def show
    
  end


end
