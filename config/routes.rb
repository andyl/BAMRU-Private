Zn::Application.routes.draw do

  get "home/index"
  get "home/test"
  get "home/tbd"
  get "home/contact"
  get "home/labs"
  get "home/wiki"
  get "home/edit_info"
  get "home/mail_sync"
  get "home/silent_mail_sync"
  get "home/preview"
  get "home/testrake"
  get "home/readstats"

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
  resources  :files
  resources  :rsvp_templates
  resources  :history
  resources  :rsvps

  get '/messages/:id/update_rsvp' => "messages#update_rsvp"

  get  '/do_planner'     => "do_planner#index"
  post '/do_planner/:id' => "do_planner#update"

  resources  :members do
    resources  :photos
    resources  :certs
    resources  :avail_dos
    resource   :avail_ops
    resources  :inbox, :controller => :inbox
  end

  get  "/chat1" => "chat1#index"
  post "/chat1" => "chat1#create"

  get  "/chat2" => "chat2#index"
  post "/chat2" => "chat2#create"
  namespace "chat2" do
    resources :chats
  end

  get  "mobile1" => "mobile1#index", :as => "mobile1"
  post "mobile1/send_page" => "mobile1#send_page"
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

  get "mobile"   => "mobile3#index"
  get "mobile3"  => "mobile3#index"
  post "mobile3/send_page" => "mobile3#send_page"
  get "mobile/login"    => "mobile3/sessions#new"
  get "mobile3/login"   => "mobile3/sessions#new",     :as => "mobile_login"
  get "mobile3/logout"  => "mobile3/sessions#destroy", :as => "mobile_logout"
  namespace "mobile3" do
    resources :sessions
  end

  get "mobile4"  => "mobile4#index"
  get "mobile4/login"   => "mobile4/sessions#new",     :as => "mobile_login"
  get "mobile4/logout"  => "mobile4/sessions#destroy", :as => "mobile_logout"
  namespace "mobile4" do
    resources :sessions
  end

  get "monitor"  => "monitor#index"
  get "monitor/login"   => "monitor/sessions#new",     :as => "monitor_login"
  get "monitor/logout"  => "monitor/sessions#destroy", :as => "monitor_logout"
  namespace "monitor" do
    resources :sessions
  end  

  get "mtimer" => "mtimer#index"

  namespace "api" do

    namespace "rake" do
      get  "messages"                     => "messages#index"
      get  "messages/render_notice"       => "messages#render_notice"
      get  "messages/:id/sent_at_now"     => "messages#sent_at_now"
      get  "messages/load_inbound"        => "messages#load_inbound"
      post "messages/update_sent_at"      => "messages#update_sent_at"
      get  "password/reset"               => "password#reset"
      get  "ops/set_do"                   => "ops#set_do"
      get  "ops/message_cleanup"          => "ops#message_cleanup"
      get  "ops/avail_op_cleanup"         => "ops#avail_op_cleanup"
      get  "reminders/do_shift_pending"   => "reminders#do_shift_pending"
      get  "reminders/do_shift_starting"  => "reminders#do_shift_starting"
      get  "reminders/cert_expiration"    => "reminders#cert_expiration"
    end

    get  "mobile3" => "mobile3#index"
    namespace "mobile3" do
      resources :members
      resources :messages
      get      "do"
      get      "rsvp"
    end

    get  "chat2" => "chat2#index"
    namespace "chat2" do
      resource :chats
    end

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

  match '/icon/:label.gif'         => "icon#show"

  root :to => 'home#index'

  if %w(development test).include? Rails.env
    mount Jasminerice::Engine => "/jasmine"
    mount Jasminerice::Engine => "/jas2"
    mount Jasminerice::Engine => "/jas3"
  end

  manifest_mobile3 = Rack::Offline.configure do
    cache "/favicon_d1.ico"
    cache "/favicon_p1.ico"
    cache "/assets/mobile3/application.js"
    cache "/assets/mobile3.css"
    cache "/images/icons.css"
    cache "/images/icons.png"
    cache "/assets/s.gif"
    network "/"
  end

  manifest_mobile4 = Rack::Offline.configure do
    cache "/favicon_d1.ico"
    cache "/favicon_p1.ico"
    cache "/assets/mobile4/application.js"
    cache "/assets/mobile3.css"

    network "/"
    network "http://maps.google.com"
    network "http://maps.gstatic.com"
    network "http://csi.gstatic.com"
    network "http://maps.googleapis.com"
    network "http://mt0.googleapis.com"
    network "http://mt1.googleapis.com"
    network "http://mt2.googleapis.com"
    network "http://mt3.googleapis.com"
    network "http://khm0.googleapis.com"
    network "http://khm1.googleapis.com"
    network "http://cbk0.googleapis.com"
    network "http://cbk1.googleapis.com"
    network "http://www.google-analytics.com"
    network "http://gg.google.com"
  end

  manifest_mtimer = Rack::Offline.configure do
    cache "/assets/mtimer.css"
    cache "/assets/mtimer/all_mtimer.js"
    cache "/ding.wav"

    network "/"
  end

  match "/mobile3f.manifest"     => manifest_mobile3
  match "/mobile4f.manifest"     => manifest_mobile4
  match "/mtimerf.manifest"      => manifest_mtimer

end
