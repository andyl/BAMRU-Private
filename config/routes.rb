Zn::Application.routes.draw do

  get "home/index"
  get "home/test"
  get "home/tbd"
  get "home/contact"
  get "home/mobile"
  get "home/xmobile"
  get "home/wiki"
  get "home/edit_info"
  get "home/mail_sync"
  get "home/silent_mail_sync"
  get "home/preview"
  get "home/testrake"

  get "preview/sms"
  get "preview/mail_txt"
  get "preview/mail_htm"
  get "preview/init_opts"

  get "login"  => "sessions#new",     :as => "login"
  get "logout" => "sessions#destroy", :as => "logout"

  get  "password/forgot" 
  post "password/send_email"   # collects an email address and sends email
  get  "password/sending"      # user notice after the email has been sent

  get  "password/reset"        # link embedded in the email goes to this page
  put  "password/update"       # updates the password after token is accepted

  get '/history/markall'
  get '/history/disable'
  get '/history/ignore'

  resources  :sessions
  resources  :members
  resources  :messages
  resources  :unit_photos
  resources  :unit_certs
  resources  :unit_avail_ops
  resources  :do_assignments
  resources  :do_handoffs
  resources  :files
  resources  :chats
  resources  :rsvp_templates
  resources  :history
  resources  :rsvps

  resources  :members do
    resources  :photos
    resources  :certs
    resources  :avail_dos
    resource   :avail_ops
    resources  :inbox, :controller => :inbox
  end

  get "mobile1" => "mobile1#index", :as => "mobile1"
  get "mobile1/login"   => "mobile1/sessions#new",     :as => "mobile_login"
  get "mobile1/logout"  => "mobile1/sessions#destroy", :as => "mobile_logout"
  namespace "mobile1" do
    get "about"
    get "map"
    get "geo"
    get "unread"
    get "inbox"
    get "paging"
    get "status"
    resources :members
    resources :messages
    resources :sessions
    resources :chats
  end

  get "mobile2" => "mobile2#index"
  namespace "mobile2" do
    resources :members
    resources :messages
  end

  namespace "api" do
    get  "mails"                 => "mails#index"
    get  "mails/:id/sent_at_now" => "mails#sent_at_now"
    post "mails/inbound"         => "mails#inbound"
  end

  match '/members/:member_id/photos/sort' => "photos#sort",         :as => :sort_member_photos
  match '/members/:member_id/certs/sort'  => "certs#sort",          :as => :sort_member_certs
  match '/rsvp_templates/sort'            => "rsvp_templates#sort", :as => :sort_rsvp_templates

  match '/reports'                 => "reports#index"
  match '/reports/gdocs/uploading' => "reports#gdocs_uploading"
  match '/reports/gdocs/auth'      => "reports#gdocs_auth"
  match '/reports/gdocs/request'   => "reports#gdocs_request"
  match '/reports/gdocs/show'      => "reports#gdocs_show"
  match '/reports/gdocs/:title'    => "reports#gdocs_show"
  match '/reports/:title'          => "reports#show"


  if %w(development test).include? Rails.env
    mount Jasminerice::Engine => "/jasmine"
  end

  offline = Rack::Offline.configure do
    cache "http://code.jquery.com/jquery-1.6.2.min.js"
    cache "/stylesheets/jquery.mobile-1.0rc1.css"
    cache "/favicon_d1.ico"
    cache "/favicon_p1.ico"
    cache "/images/jqm/ajax-loader.png"
    cache "/images/jqm/icons-18-black.png"
    cache "/images/jqm/icons-18-white.png"
    cache "/images/jqm/icons-36-black.png"
    cache "/images/jqm/icons-36-white.png"
    cache "/assets/mobile2/all_mobile2.js"

    network "/"
  end

  match "/jqm_mobile.manifest" => offline

  root :to => 'home#index'

end
