class UnitOotsController < ApplicationController
  def index
    @members = Member.all
  end
end
