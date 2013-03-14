source "http://rubygems.org"

ruby "1.9.3"

# ----- rails -----
gem "rails",        "3.2.12"
gem "rake",         "10.0.3"

# ----- web servers -----
gem "thin"                  # required by faye
gem "passenger", "3.0.12"   # production server
gem "unicorn"

# ----- 3rd party services -----
gem "ruby-gmail", :require => "gmail"
gem "gcal4ruby"

# ----- database -----
gem "yaml_db"
gem "pg"

# ----- services and protocols -----
gem "faye",    "0.6.8"         # messaging-pub/sub infrastructure
gem "net-ssh", "2.2.2"

# ----- process management -----
gem "foreman"                     # init/upstart - see `Procfile`
gem "whenever", :require => false # cron jobs - see `schedule.rb`
gem "queue_classic", "2.1.1"      # background job queue

# ----- asset management -----
gem "sprite-factory"
gem "paperclip",      "3.3.1"
gem "rmagick"

# ----- view utilities -----
gem "rabl"
gem "pngqr"          # generate QR codes
gem "simple_form"
gem "dynamic_form"
gem "draper", "0.18.0"

# ----- misc -----
gem "aalf",      :git => "http://github.com/andyl/aalf.git"
gem "mime"
gem "cancan"         # access control
gem "cocaine"        # ???
gem "parslet"        # address parsing
gem "ancestry"       # ???
gem "nokogiri"
gem "fastercsv"
gem "acts_as_api"
gem "rb-readline"
gem "em-http-request"
gem "json", "~> 1.5.1"
gem "exception_notification"
gem "bcrypt-ruby", "~> 3.0.0"

# ----- mail -----
gem "mail"

# ----- pdf generation -----
gem "prawn", "~> 0.12.0"   # for PDF reports
gem "pdfkit"               # PDF screenshots of a URL 

# ----- javascript processing -----
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

# ----- vagrant support -----
gem "ghost"             # manages /etc/hosts for testing

group :assets do
  # gem "coffee-script"
  # gem "libv8", '~> 3.11.8'
  # gem "therubyracer", :require => "v8"

  gem "sass"
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"

  gem "turbo-sprockets-rails3"

  gem "uglifier", ">= 1.0.3"
  gem "therubyracer", :platforms => :ruby

end

group :development, :test do

  # ----- misc -----
  gem "zeus", "0.13.3"    # environment pre-loader
  gem "debugger", :require => "ruby-debug"

  # ----- capistrano -----
  gem "capistrano"
  gem "capistrano_colors"

  # ----- javascript unit tests -----
  gem "faker"
  gem "guard"
  gem "simplecov"
  gem "csv-mapper"
  gem "rb-inotify"
  gem "jasminerice"
  gem "guard-coffeescript"
  gem "coffee-rails-source-maps"

  # ----- rspec -----
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "rspec-on-rails-matchers"

  # ----- test helpers -----
  gem "database_cleaner"
  gem "factory_girl_rails"

  # ----- capybara -----
  gem "launchy"
  gem "capybara"
  gem "capybara-webkit"
  gem "selenium-webdriver"

  # ----- mail testing -----
  gem "letter_opener"       # opens email in a local browser
  gem "mail_view", :git => "git://github.com/andyl/mail_view.git"

  # ----- misc -----
  gem "bullet"            # generates alert on N+1 queries

  # ----- add DB fields too models & specs -----
  gem "annotate"

  # ----- RubyMine Support -----
  # run this to get the debugger working on RubyMine
  # > curl -OL http://rubyforge.org/frs/download.php/75414/linecache19-0.5.13.gem
  # > gem install linecache19-0.5.13.gem
  # > gem install --pre ruby-debug-base19x
  # gem "ruby-debug-base19x", "~> 0.11.30.pre10"

end
