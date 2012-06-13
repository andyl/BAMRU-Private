
env_settings = <<-EOF
APP_NAME
GOOGLE_CONSUMER_KEY
GOOGLE_CONSUMER_SECRET
FAYE_TOKEN
FAYE_SERVER
PRODUCTION_GMAIL_USER
PRODUCTION_GMAIL_PASS
STAGING_GMAIL_USER
STAGING_GMAIL_PASS
STAGING_VALID_EMAILS
STAGING_DELIVERY_ADDRESS
SYSTEM_USER
SYSTEM_PASS
POSTGRES_PASS
ALERT_EMAILS
SES_SMTP_SRVR
SES_SMTP_USER
SES_SMTP_PASS
EOF

env_settings.each_line do |val|
  constant = val.chomp.strip
  eval "#{constant} = ENV['#{constant}']"
  abort "ERROR: Missing Environment Value (#{constant})" if constant.nil?
end

if defined?(Rails)
   GMAIL_USER = Rails.env.production? ? PRODUCTION_GMAIL_USER : STAGING_GMAIL_USER
   GMAIL_PASS = Rails.env.production? ? PRODUCTION_GMAIL_PASS : STAGING_GMAIL_PASS
else
   GMAIL_USER = STAGING_GMAIL_USER
   GMAIL_PASS = STAGING_GMAIL_PASS
end

SMTP_SETTINGS = {
  # :address              => "smtp.gmail.com",
  # :domain               => "gmail.com",
  :address              => SES_SMTP_SRVR,
  :port                 => 587,
  :user_name            => SES_SMTP_USER,
  :password             => SES_SMTP_PASS,
  :authentication       => "plain",
  :enable_starttls_auto => true
}

