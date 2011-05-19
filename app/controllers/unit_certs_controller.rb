class UnitCertsController < ApplicationController
  def index
    @members = Member.all
  end
end
