require 'json'
require 'faye'

LOG_DIR = Rails.root.to_s + '/log'
LOG_FILE = LOG_DIR + '/monitor.log'

def write_log(data)
  File.open(LOG_FILE, 'a') {|f| f.puts data.to_json}
  system "tail -n 80 #{LOG_FILE} > #{LOG_FILE}.tmp"
  system "mv #{LOG_FILE}.tmp #{LOG_FILE}"
  send_faye(data)
end

def send_faye(data)
  message = {:channel => '/monitor/events', :data => data.to_json}
  uri = URI.parse(FAYE_SERVER)
  Net::HTTP.post_form(uri, :message => message.to_json)
end

def prep_data(args)
  data = {}
  data[:id]     = Time.now.to_i
  data[:event]  = args[0]
  data[:time]   = args[1].strftime("%H:%M:%S")
  data[:member] = args[4][:member].try(:monitor_name) || "----"
  data[:text]   = args[4][:text] if args[4][:text]
  data
end

event_list = /ops|service|logout|login|password|rake/

ActiveSupport::Notifications.subscribe(event_list) do |*args|
  data = prep_data(args)
  write_log(data)
end
