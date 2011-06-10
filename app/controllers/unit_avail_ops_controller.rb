class UnitAvailOpsController < ApplicationController
  def index
    @members   = Member.all
  end
end
