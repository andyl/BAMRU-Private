class UnitAvailOpsController < ApplicationController
  def index
    @avail_ops = AvailOp.all
  end
end
