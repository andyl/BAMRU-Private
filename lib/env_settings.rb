
env_settings = <<-EOF
APP_NAME
GOOGLE_CONSUMER_KEY
GOOGLE_CONSUMER_SECRET
FAYE_TOKEN
FAYE_SERVER
GMAIL_USER
GMAIL_PASS
SYSTEM_USER
SYSTEM_PASS
POSTGRES_PASS
EOF

env_settings.each_line do |val|
  constant = val.chomp.strip
  eval "#{constant} = ENV['#{constant}']"
  abort "ERROR: Missing Environment Value (#{constant})" if constant.nil?
end









