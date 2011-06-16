class UnitAvailOpsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @members   = Member.all
  end
end
