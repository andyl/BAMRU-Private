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

end