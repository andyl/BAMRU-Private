
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
SYSTEM_USER
SYSTEM_PASS
POSTGRES_PASS
ALERT_EMAILS
EOF

env_settings.each_line do |val|
  constant = val.chomp.strip
  eval "#{constant} = ENV['#{constant}']"
  abort "ERROR: Missing Environment Value (#{constant})" if constant.nil?
end

GMAIL_USER = Rails.env.production? ? PRODUCTION_GMAIL_USER : STAGING_GMAIL_USER
GMAIL_PASS = Rails.env.production? ? PRODUCTION_GMAIL_PASS : STAGING_GMAIL_PASS

SMTP_SETTINGS = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => GMAIL_USER,
  :password             => GMAIL_PASS,
  :authentication       => "plain",
  :enable_starttls_auto => true
}
