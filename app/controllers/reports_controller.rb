class ReportsController < ApplicationController

  before_filter :authenticate_member!

  def index
  end

  def show
    @members = Member.order_by_last_name.all
    render params[:title] + '.' + params[:format], :layout => nil
  end

end
