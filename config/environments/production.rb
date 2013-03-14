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
  config.assets.compile  = false
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
  config.assets.precompile += %w(bb_debug.js events/all_events.js messages/all_messages_indx.js)
  config.assets.precompile += %w(history/all_history.js messages/all_messages_show.js members/all_mem_indx.js)
  config.assets.precompile += %w(unit_certs/all_unit_certs.js unit_avail_ops/all_unit_avail_ops.js)
  config.assets.precompile += %w(do_planner.js avail_dos/all_avail_dos.js reports/all_reports.js)
  config.assets.precompile += %w(inbox/all_inbox_indx.js guests/all_guests_indx.js)
  config.assets.precompile += %w(mobile.css monitor.css mobile/all_mobile.js)
  config.assets.precompile += %w(files/all_files.js members/all_mem_show.js members/all_mem_edit.js)
  config.assets.precompile += %w(avail_ops/all_avail_ops.js certs/all_certs_indx.js)
  config.assets.precompile += %w(guests/all_guest_show.js certs/all_certs_edit.js)
  config.assets.precompile += %w(sessions/all_sessions.js mobile_ui.css)
  config.assets.precompile += %w(meeting_signin/all_meeting_signin.js)

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
  config.middleware.use ExceptionNotifier,
    sender_address: GMAIL_USER,
    exception_recipients: EXCEPTION_ALERT_EMAILS.split(' ')

end
