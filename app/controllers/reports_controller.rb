class ReportsController < ApplicationController

  before_filter :authenticate_member_for_reports

  def index
    @report_list = [
    ["Map List",   'BAMRU-roster.html', "HTML Roster with Gmap links"],
    ["CSV Report", 'BAMRU-roster.csv',  "for importing into Excel"],
    ["Hello World",'HelloWorld.pdf',    "prototype/proof of concept"],
    ["BAMRU Names",'BAMRU-names.pdf',   "list of names for ProDeal reporting"]
    ]
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

