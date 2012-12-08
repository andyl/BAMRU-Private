class EventReportsController < ApplicationController

  before_filter :authenticate_member_with_basic_auth!

  def index
    @event_reports = EventReport.all
  end

  def show
    @event_report = EventReport.find(params[:id])
    args = {:layout => nil}
    render @event_report.template, args
  end

  protected

  def cx_type(format)
    case format.upcase
      when "XLS"  then 'application/vnd.ms-excel'
      when "PDF"  then 'application/pdf'
      when "CSV"  then 'text/csv'
      when "VCF"  then 'text/plain'
      when "HTML" then "text/html"
      else "text/plain"
    end
  end
  
  def save_params_to_session(params)
    title = params[:title]   || session[:title]
    format = params[:format] || session[:format]
    session[:title]  = title
    session[:format] = format
    [title, format]
  end

end

