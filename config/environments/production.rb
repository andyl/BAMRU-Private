Zn::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between features
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.compile  = true
  config.assets.digest   = true
  config.assets.initialize_on_precompile = false

  # Specifies the header that your server uses for sending files
  # (comment out if your front-end server doesn't support this)
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # Use 'X-Accel-Redirect' for nginx
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  js_prefix = "app/assets/javascripts/"
  config.assets.precompile += Dir.glob("#{js_prefix}*/all_*.js").map {|x| x.gsub(js_prefix, "")}
  config.assets.precompile += Dir.glob("#{js_prefix}*.js.coffee").map {|x| x.gsub(js_prefix, "").gsub(".coffee", "")}
  config.assets.precompile += %w(mobile.css monitor.css mobile_ui.css tipsy.css mobile_signup.css)
  config.assets.precompile += %w(zurb.css zurb.js)

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Exception Notification
  # config.middleware.use ExceptionNotifier,
  #   sender_address: GMAIL_USER,
  #   exception_recipients: EXCEPTION_ALERT_EMAILS.split(' ')

end
