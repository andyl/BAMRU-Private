class ReportsController < ApplicationController

  before_filter :authenticate_member_for_reports

  def index
  end

  def show
    @members = Member.order_by_last_name.all
    render params[:title] + '.' + params[:format], :layout => nil
  end

  protected

  # can be called with curl using http_basic authentication
  # curl -u user:pass http://bamru.net/reports
  # curl -u user:pass http://bamru.net/reports/BAMRU-report.csv
  def authenticate_member_for_reports
    if member = authenticate_with_http_basic { |u,p| Member.find_by_user_name(u).authenticate(p) }
      session[:member_id] = member.id
    else
      authenticate_member!
    end
  end

end

