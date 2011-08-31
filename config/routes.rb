Zn::Application.routes.draw do

  get "home/index"
  get "home/test"
  get "home/tbd"
  get "home/contact"
  get "home/mobile"
  get "home/wiki"
  get "home/edit_info"

  get "login"  => "sessions#new",     :as => "login"
  get "logout" => "sessions#destroy", :as => "logout"

  get  "password/forgot" 
  post "password/send_email"   # collects an email address and sends email
  get  "password/sending"      # user notice after the email has been sent

  get  "password/reset"        # link embedded in the email goes to this page
  put  "password/update"       # updates the password after token is accepted

  resources :sessions

  resources  :members
  resources  :messages
  resources  :unit_photos
  resources  :unit_certs
  resources  :unit_avail_ops
  resources  :do_assignments
  resources  :files
  resources  :chats

  resources  :members do
    resources  :photos
    resources  :certs
    resources  :avail_dos
    resource   :avail_ops
  end

  get "mobile" => "mobile#index", :as => "mobile"
  get "mobile/about"
  get "mobile/map"
  get "mobile/geo"
  get "mobile/geo2"

  get "mobile/login"  => "mobile/sessions#new",     :as => "mobile_login"
  get "mobile/logout" => "mobile/sessions#destroy", :as => "mobile_logout"
  
  namespace "mobile" do
    resources :members
    resources :sessions
    resources :chats
  end

  match '/members/:member_id/photos/sort' => "photos#sort", :as => :sort_member_photos
  match '/members/:member_id/certs/sort'  => "certs#sort",  :as => :sort_member_certs

  match '/reports'                 => "reports#index"
  match '/reports/gdocs/uploading' => "reports#gdocs_uploading"
  match '/reports/gdocs/auth'      => "reports#gdocs_auth"
  match '/reports/gdocs/request'   => "reports#gdocs_request"
  match '/reports/gdocs/show'      => "reports#gdocs_show"
  match '/reports/gdocs/:title'    => "reports#gdocs_show"
  match '/reports/:title'          => "reports#show"

  root :to => 'home#index'

end
