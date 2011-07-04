class MobileController < ApplicationController

  before_filter :authenticate_mobile_member!

  layout 'mobile'

  def index
  end

  def about
  end

  def tbd
  end

  def contact
  end

  def map
  end

  def geo
  end

  def geo2
  end

end