Zn::Application.routes.draw do

  get "home/admin"
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
  get "home/browserstats"
  get "home/event_publishing"

  get "public/calendar"

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
  resources  :event_reports
  resources  :data_files

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

  get "mobile"   => "mobile3#index"
  get "mobile3"  => "mobile3#index"
  post "mobile3/send_page" => "mobile3#send_page"
  get "mobile/login"    => "mobile3/sessions#new"
  get "mobile3/login"   => "mobile3/sessions#new",     :as => "mobile_login"
  get "mobile3/logout"  => "mobile3/sessions#destroy", :as => "mobile_logout"
  namespace "mobile3" do
    resources :sessions
  end

  get "monitor"  => "monitor#index"
  get "monitor/login"   => "monitor/sessions#new",     :as => "monitor_login"
  get "monitor/logout"  => "monitor/sessions#destroy", :as => "monitor_logout"
  namespace "monitor" do
    resources :sessions
  end  

  get '/events'                => 'events#index'
  get '/events/:id'            => 'events#index'
  get '/events/:id/edit'       => 'events#index'
  get '/events/:id/roster'     => 'events#index'
  get '/events/:id/forum'      => 'events#index'
  get '/events/:id/resources'  => 'events#index'
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

    get  "mobile3" => "mobile3#index"
    namespace "mobile3" do
      resources :members
      resources :messages
      get      "do"
      get      "rsvp"
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
    mount Jasminerice::Engine => "/jasmine/:environment"
  end

end
