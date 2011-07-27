class UnitPhotosController < ApplicationController

  before_filter :authenticate_member!
  caches_action :index, :layout => false

  def index
    @members = Member.with_photos.order_by_last_name.all
  end

end
