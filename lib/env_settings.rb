env_settings = <<-EOF
APP_NAME
GOOGLE_DOCS_CONSUMER_KEY
GOOGLE_DOCS_CONSUMER_SECRET
FAYE_TOKEN
FAYE_SERVER
GMAIL_STAGING_SMTP_SRVR
GMAIL_STAGING_SMTP_USER
GMAIL_STAGING_SMTP_PASS
GMAIL_PRODUCTION_SMTP_SRVR
GMAIL_PRODUCTION_SMTP_USER
GMAIL_PRODUCTION_SMTP_PASS
GCAL_STAGING_USER
GCAL_STAGING_PASS
GCAL_PRODUCTION_USER
GCAL_PRODUCTION_PASS
STAGING_VALID_EMAILS
SYSTEM_USER
SYSTEM_PASS
POSTGRES_PASS
EXCEPTION_ALERT_EMAILS
SES_SMTP_SRVR
SES_SMTP_USER
SES_SMTP_PASS
MANDRILL_SMTP_SRVR
MANDRILL_SMTP_USER
MANDRILL_SMTP_PASS
EOF

env_settings.each_line do |val|
  constant = val.chomp.strip
  tmp = nil
  eval "tmp = ENV['#{constant}']"
  #puts "#{constant.ljust(35, '-')} #{tmp}"
  abort "ERROR: Missing Environment Value (#{constant})" if tmp.nil?
  eval "#{constant} = tmp"
end

GMAIL_SRVR = "smtp.gmail.com"

if defined?(Rails)
   GMAIL_USER = Rails.env.production? ? GMAIL_PRODUCTION_SMTP_USER : GMAIL_STAGING_SMTP_USER
   GMAIL_PASS = Rails.env.production? ? GMAIL_PRODUCTION_SMTP_PASS : GMAIL_STAGING_SMTP_USER
   GCAL_USER  = Rails.env.production? ? GCAL_PRODUCTION_USER  : GCAL_STAGING_USER
   GCAL_PASS  = Rails.env.production? ? GCAL_PRODUCTION_PASS  : GCAL_STAGING_USER
else
   GMAIL_USER = GMAIL_PRODUCTION_SMTP_USER
   GMAIL_PASS = GMAIL_PRODUCTION_SMTP_USER
   GCAL_USER  = GCAL_PRODUCTION_USER
   GCAL_PASS  = GCAL_PRODUCTION_PASS
end

mailservice="gmail"

mandrill_opts = [MANDRILL_SMTP_SRVR, MANDRILL_SMTP_USER, MANDRILL_SMTP_PASS]
ses_opts      = [SES_SMTP_SRVR     , SES_SMTP_USER     , SES_SMTP_PASS]
gmail_opts    = [GMAIL_SRVR        , GMAIL_USER        , GMAIL_PASS]
  
srvr, user, pass = case mailservice
                   when "mandrill" then mandrill_opts
                   when "ses"      then ses_opts
                   else gmail_opts
                   end

SMTP_SETTINGS = {
  :address              => srvr,
  :user_name            => user,
  :password             => pass,
  :domain               => "gmail.com",
  :port                 => 587,
  :authentication       => "plain",
  :enable_starttls_auto => true
}
