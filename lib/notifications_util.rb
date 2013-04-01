
LOG_DIR = Rails.root.to_s + '/log'
LOG_FILE = LOG_DIR + '/monitor.log'

def write_log(data)
  File.open(LOG_FILE, 'a') {|f| f.puts data.to_json}
  system "tail -n 120 #{LOG_FILE} > #{LOG_FILE}.tmp"
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

def send_alerts(args)
  return unless args[0].split('.').first == "alert"
  data = {}
  data[:event]  = args[0].split('.')[1]
  data[:time]   = args[1].strftime("%m-%d %H:%M:%S")
  data[:member] = args[4][:member].full_name
  tgt = args[4][:tgt]
  lbl = if tgt.is_a? Event
          "#{tgt.typ} | #{tgt.title}"
        else
          "#{tgt.try(:full_name)} | Role: #{tgt.try(:typ)}"
        end
  data[:tgt]    = lbl
  Notifier.event_alert(data).deliver
end
