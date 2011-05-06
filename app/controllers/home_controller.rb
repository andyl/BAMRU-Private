class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  def index
  end

  def contact
  end

  def tbd
  end

end
