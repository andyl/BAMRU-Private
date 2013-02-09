source "http://rubygems.org"

ruby "1.9.3"

gem "rails",        "3.2.11"

gem "cocaine",      :git => 'http://github.com/thoughtbot/cocaine.git'

gem "sqlite3"
gem "rake"
gem "faye",         "0.6.8"
gem "pngqr"
gem "em-http-request"
gem "thin"
gem "gcal4ruby"
gem "ancestry"
gem "haml-rails"
gem "net-ssh", "2.2.2"

gem "queue_classic", "2.1.1"
gem "exception_notification"

gem "twilio-ruby"

gem "yaml_db"

gem "pg"

gem "acts_as_api"

gem "aws-ses", :require => "aws/ses"

gem "fastercsv"
gem "nokogiri"
gem "simple_form"
gem "rabl"
gem "sprite-factory"
gem "rmagick"

gem "ghost"
gem "valkyrie"

gem "draper"
gem "passenger", "3.0.12"

gem "aalf",      :git => "http://github.com/andyl/aalf.git"
gem "mail_view", :git => "git://github.com/andyl/mail_view.git"

gem "paperclip",    "3.3.1"
gem "parslet"
gem "dynamic_form"
gem "cancan"
gem "mail"
gem "prawn", "~> 0.12.0"
gem "pdfkit"
gem "foreman"
gem "oauth"
gem "ruby-gmail", :require => "gmail"
gem "mime"
gem "bcrypt-ruby", "~> 3.0.0"

# Asset template engines
# gem "jquery-rails"
gem "jsgem-jquery",        "1.7.2.pre2"
gem "jsgem-jquery-ui",     "1.9.1.pre2"
gem "jsgem-jquery-layout", "1.3.0.pre2"
gem "json"
gem "sass"
gem "coffee-script"
gem "uglifier"
gem "libv8", '~> 3.11.8'
gem "therubyracer", :require => "v8"
gem "whenever",     :require => false
gem "eco"

# console tools
gem "hirb"
gem "wirble"
gem "interactive_editor"
gem "awesome_print", :require => "ap"
gem "drx"

group :development, :test do

  # ----- misc -----
  gem "zeus"        # fast environment launch
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
  gem "database_cleaner"
  gem "factory_girl_rails"

  # ----- capybara -----
  gem "capybara"
  gem "capybara-webkit"
  gem "selenium-webdriver"
  gem "launchy"

  # ----- vagrant -----
  gem "vagrant", "1.0.6"
  gem "virtualbox"
  gem "vagrant-snap"

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
