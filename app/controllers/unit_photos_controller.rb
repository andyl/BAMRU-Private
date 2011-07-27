class UnitPhotosController < ApplicationController

  before_filter :authenticate_member!
  caches_action :index

  def index
    @members = Member.with_photos.order_by_last_name.all
  end

end
