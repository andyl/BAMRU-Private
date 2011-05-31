class UnitPhotosController < ApplicationController

  def index
    @members = Member.with_photos.order_by_last_name.all
  end

end
