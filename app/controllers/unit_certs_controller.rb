class UnitCertsController < ApplicationController

  before_filter :authenticate_member!

  def index
    @members = Member.order_by_last_name.all
  end
end
