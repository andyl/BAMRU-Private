source "http://rubygems.org"

ruby "1.9.3"

# ----- rails -----
gem "rails",        "3.2.12"
gem "rake",         "10.0.3"

# ----- web servers -----
gem "thin"                  # required by faye
gem "passenger", "3.0.12"   # production server

# ----- 3rd party services -----
gem "ruby-gmail", :require => "gmail"
gem "twilio-ruby"
gem "gcal4ruby"
# gem "aws-ses", :require => "aws/ses"

# ----- database -----
gem "sqlite3"
gem "valkyrie"
gem "yaml_db"
gem "pg"

# ----- services and protocols -----
gem "faye",    "0.6.8" # messaging-pub/sub infrastructure
gem "net-ssh", "2.2.2"

# ----- process management -----
gem "foreman"                     # init/upstart - see `Procfile`
gem "whenever", :require => false # cron jobs - see `schedule.rb`
gem "queue_classic", "2.1.1"      # background job queue

# ----- asset management -----
gem "sprite-factory"
gem "rmagick"
gem "paperclip",    "3.3.1"
gem "sass"

# ----- view utilities -----
gem "draper"
gem "rabl"
gem "simple_form"
gem "dynamic_form"
gem "pngqr"  # generate QR codes
gem "haml-rails"

# ----- misc -----
gem "aalf",      :git => "http://github.com/andyl/aalf.git"
gem "acts_as_api"
gem "ancestry"
gem "bcrypt-ruby", "~> 3.0.0"
gem "cancan"
gem "cocaine",      :git => 'http://github.com/thoughtbot/cocaine.git'
gem "em-http-request"
gem "exception_notification"
gem "fastercsv"
gem "json"
gem "mime"
gem "nokogiri"
gem "oauth"
gem "parslet"

# ----- mail -----
gem "mail"
gem "mail_view", :git => "git://github.com/andyl/mail_view.git"

# ----- pdf generation -----
gem "prawn", "~> 0.12.0" # for PDF reports
gem "pdfkit"             # PDF screenshots of a URL 

# ----- javascript processing -----
gem "coffee-script"
gem "uglifier"
gem "libv8", '~> 3.11.8'
gem "therubyracer", :require => "v8"
gem "eco"

# ----- javascript libraries -----
gem "jsgem-jquery",        "1.7.2.pre2"
gem "jsgem-jquery-ui",     "1.9.1.pre2"
gem "jsgem-jquery-layout", "1.3.0.pre2"

# ----- console tools -----
gem "hirb"
gem "wirble"
gem "interactive_editor"
gem "awesome_print", :require => "ap"
gem "drx"

group :development, :test do

  # ----- misc -----
  gem "zeus"        # environment pre-loader
  gem "debugger", :require => "ruby-debug"

  # ----- capistrano -----
  gem "capistrano"
  gem "capistrano_colors"

  # ----- javascript unit tests -----
  gem "jasminerice"
  gem "csv-mapper"
  gem "rb-inotify"
  gem "guard"
  gem "guard-coffeescript"
  gem "faker"
  gem "simplecov"

  # ----- rspec -----
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "rspec-on-rails-matchers"

  # ----- test helpers -----
  gem "database_cleaner"
  gem "factory_girl_rails"

  # ----- capybara -----
  gem "capybara"
  gem "capybara-webkit"
  gem "selenium-webdriver"
  gem "launchy"

  # ----- vagrant -----
  gem "vagrant", "1.0.6"  # generate test machines
  gem "virtualbox"        # VM engine
  gem "vagrant-snap"      # generates VM snapshots
  gem "ghost"             # manages /etc/hosts for testing

  # ----- email testing -----
  gem "letter_opener"
  gem "bullet"

  # ----- add DB fields too models & specs -----
  gem "annotate", :git => 'git://github.com/jeremyolliver/annotate_models.git', :branch => 'rake_compatibility'

  # ----- RubyMine Support -----
  # run this to get the debugger working on RubyMine
  # > curl -OL http://rubyforge.org/frs/download.php/75414/linecache19-0.5.13.gem
  # > gem install linecache19-0.5.13.gem
  # > gem install --pre ruby-debug-base19x
  # gem "ruby-debug-base19x", "~> 0.11.30.pre10"

end
