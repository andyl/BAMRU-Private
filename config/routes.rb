Zn::Application.routes.draw do

  get "wiki/new"                => "wiki#new"
  get "wiki/:dir/new"           => "wiki#new"
  get "wiki/:dir/:page/new"     => "wiki#new"
  get "wiki"                    => "wiki#index"
  get "wiki/:dir"               => "wiki#index"
  get "wiki/:dir/:page/edit"    => "wiki#edit"
  get "wiki/:page/edit"         => "wiki#edit"
  get "wiki/:dir/:page/rename"  => "wiki#rename"
  get "wiki/:page/rename"       => "wiki#rename"
  get "wiki/:dir/:page/show"    => "wiki#show"
  get "wiki/:page/show"         => "wiki#show"
  get "wiki/:dir/:page/history" => "wiki#history"
  get "wiki/:page/history"      => "wiki#history"
  put "wiki/:dir/:page/rename"  => "wiki#reproc"
  put "wiki/:page/rename"       => "wiki#reproc"
  put "wiki/:dir/:page"         => "wiki#update"
  put "wiki/:page"              => "wiki#update"
  get "wiki/:page/delete"       => "wiki#destroy"
  get "wiki/:dir/:page/delete"  => "wiki#destroy"
  post "wiki"                   => "wiki#create"

  get "home/index"
  get "home/admin"
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
  get "home/browserstats"
  get "home/event_publishing"
  get "home/chrome_frame"
  get "home/changelog"
  get "home/roadmap"

  get "zesb/index"
  get "zesb/banded"
  get "zesb/blog"
  get "zesb/feed"
  get "zesb/grid"
  get "zesb/orbit"
  get "zesb/banner"
  get "zesb/sidebar"
  get "zesb/contact"
  get "zesb/marketing"
  get "zesb/realty"
  get "zesb/boxy"
  get "zesb/store"
  get "zesb/workspace"

  get "zesb/icons"
  get "zesb/tables"

  get  'registry' => "registry#index"
  get  'registry/alerts'
  get  'registry/roles'
  get  'registry/members'
  get  'registry/member_alums'
  get  'registry/member_ncs'
  get  'registry/guests'
  get  'registry/guest_alums'
  get  'registry/guest_ncs'
  get  'registry/show/:id'   => "registry#show"
  post 'registry/update/:id' => "registry#update"

  get "public/calendar"
  get "public/calendar2"

  get "preview/sms"
  get "preview/mail_txt"
  get "preview/mail_htm"
  get "preview/init_opts"

  get 'subscription/set/:event/:role' => "subscription#set"
  get 'subscription/del/:event/:role' => "subscription#del"

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

  get '/guests/new_form' => "guests#new_form"

  resources  :sessions
  resources  :members
  resources  :guests
  resources  :messages
  resources  :inbound_mails
  resources  :unit_photos
  resources  :unit_certs
  resources  :unit_avail_ops
  resources  :do_assignments
  resources  :files
  resources  :rsvp_templates
  resources  :history
  resources  :rsvps
  resources  :unauth_rsvps
  resources  :event_photos
  resources  :event_files
  resources  :data_files
  resources  :event_reports

  resources :event_file_svcs
  resources :event_photo_svcs
  resources :event_link_svcs

  get '/messages/:id/update_rsvp' => "messages#update_rsvp"

  get '/nexmo' => "nexmo#inbound"

  get  '/do_planner'     => "do_planner#index"
  post '/do_planner/:id' => "do_planner#update"

  resources  :members do
    resources  :photos
    resources  :certs
    resources  :avail_dos
    resource   :avail_ops
    resources  :inbox, :controller => :inbox
  end

  get  "mobile"             => "mobile#index"
  get  "mobile/members"     => "mobile#index"
  get  "mobile/members/:id" => "mobile#index"
  get  "mobile/status"      => "mobile#index"
  get  "mobile/profile"     => "mobile#index"
  post "mobile/send_page"   => "mobile#send_page"
  get  "mobile/login"       => "mobile/sessions#new"
  get  "mobile/login"       => "mobile/sessions#new",     :as => "mobile_login"
  get  "mobile/logout"      => "mobile/sessions#destroy", :as => "mobile_logout"
  namespace "mobile" do
    resources :sessions
  end

  get "monitor"  => "monitor#index"
  get "monitor/login"   => "monitor/sessions#new",     :as => "monitor_login"
  get "monitor/logout"  => "monitor/sessions#destroy", :as => "monitor_logout"
  namespace "monitor" do
    resources :sessions
  end
  
  get '/meeting_signin'                      => 'meeting_signin#index'
  get '/meeting_signin/'                     => 'meeting_signin#index'
  get '/meeting_signin/autosign'             => 'meeting_signin#index'
  get '/meeting_signin/autosign/'            => 'meeting_signin#index'
  get '/meeting_signin/:event_id'            => 'meeting_signin#index'
  get '/meeting_signin/:event_id/'           => 'meeting_signin#index'
  get '/meeting_signin/:event_id/:glob'      => 'meeting_signin#index'
  get '/meeting_signin/:event_id/:g1/:g2'    => 'meeting_signin#index'

  get "/msign"                        => redirect("/meeting_signin")
  get "/meeting:glob"                 => redirect("/meeting_signin")
  get "/meeting:glob/:event_id"       => redirect("/meeting_signin/%{event_id}")
  get "/meeting:glob/:event_id/:path" => redirect("/meeting_signin/%{event_id}/%{path}")

  get '/events'                => 'events#index'
  get '/events/:id'            => 'events#index'
  get '/events/:id/edit'       => 'events#index'
  get '/events/:id/roster'     => 'events#index'
  get '/events/:id/forum'      => 'events#index'
  get '/events/:id/reference'  => 'events#index'
  get '/events/:id/reports'    => 'events#index'

  namespace "eapi" do

    resources :events do
      resources :event_links,   controller: 'events/event_links'
      resources :event_photos,  controller: 'events/event_photos'
      resources :event_files,   controller: 'events/event_files'
      resources :event_reports, controller: 'events/event_reports'
      resources :periods,       controller: 'events/periods'
    end

    resources :periods do
      resources :participants, controller: 'periods/participants'
    end

    resources :members

  end

  namespace "api" do

    namespace "rake" do
      get  "messages"                     => "messages#index"
      get  "messages/count"               => "messages#count"
      get  "messages/load_inbound"        => "messages#load_inbound"
      get  "password/reset"               => "password#reset"
      get  "ops/set_do"                   => "ops#set_do"
      get  "ops/message_cleanup"          => "ops#message_cleanup"
      get  "ops/avail_op_cleanup"         => "ops#avail_op_cleanup"
      get  "reminders/do_shift_pending"   => "reminders#do_shift_pending"
      get  "reminders/do_shift_starting"  => "reminders#do_shift_starting"
      get  "reminders/cert_expiration"    => "reminders#cert_expiration"
    end

    get  "mobile" => "mobile#index"
    namespace "mobile" do
      resources :members
      resources :messages
      get      "do"
      get      "rsvp"
    end

  end

  post '/members/:member_id/photos/sort' => "photos#sort",         :as => :sort_member_photos
  post '/members/:member_id/certs/sort'  => "certs#sort",          :as => :sort_member_certs
  post '/rsvp_templates/sort'            => "rsvp_templates#sort", :as => :sort_rsvp_templates

  get '/reports'                    => "reports#index"
  get '/reports/:title'             => "reports#show_current_report"
  get '/preports/:period_id/:title' => "reports#show_period_report"
  get '/hreports/:title'            => "reports#show_historical_report"

  get '/icon/:label.gif'         => "icon#show"

  root :to => 'home#index'

  if %w(development test).include? Rails.env
    mount Jasminerice::Engine => "/jasmine/:environment"
  end

end
