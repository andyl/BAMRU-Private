class UnitCertsController < ApplicationController
  def index
    @members = Member.order_by_last_name.all
  end
end
