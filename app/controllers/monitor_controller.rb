require 'json'

class MonitorController < ApplicationController

  before_filter { authenticate_mobile_member!('/monitor/login') }

  def snapshot_data
    log_file = Rails.root.to_s + "/tmp/perf.log"
    "[" + File.readlines(log_file).map {|x| x.chomp }.join(',') + "]"
  end

  def event_data
    log_file = Rails.root.to_s + "/log/monitor.log"
    "[" + File.readlines(log_file).map {|x| x.chomp }.join(',') + "]"
  end

  def index
    @is_ipad  = ipad_device?
    @is_phone = phone_device?
    @sensor   = phone_device? ? "true" : "false"
    @event_json = event_data
    @snapshot_json = snapshot_data
    @device   = device
    render :layout => false
  end

end
