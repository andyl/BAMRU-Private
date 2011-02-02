base_dir = File.dirname(File.expand_path(__FILE__))
require 'rubygems'
require 'yaml'
require 'ruby-debug'
require 'rack-flash'
require base_dir + '/config/environment'

class BamruApp < Sinatra::Base
  helpers Sinatra::AppHelpers

  configure do
    enable :sessions         # to store login state and calendar search settings
    use Rack::Flash          # for error and success messages
    set :erb, :trim => '-'   # strip whitespace when using <% -%>
  end

  # ----- PUBLIC PAGES -----

  # home page is static html...
  get '/' do
    redirect "/index-2.html"
  end
  
  get '/calendar.test' do
    # establish the start and finish range
    @start  = Action.date_parse(select_start_date)
    @finish = Action.date_parse(select_finish_date)
    @start, @finish  = @finish, @start if @finish < @start
    # remember start/finish settings by saving them in the session
    session[:start]  = @start
    session[:finish] = @finish
    # setup the display variables
    @title     = "BAMRU Calendar"
    @hdr_img   = "images/mtn.jpg"
    @right_nav = right_nav(:calendar)
    @right_txt = erb GUEST_POLICY, :layout => false
    @left_txt  = quote
    erb :calendar
  end

  get '/bamruinfo.test' do
    @title     = "Information about BAMRU"
    @hdr_img   = "images/approach.jpg"
    @right_nav = right_nav(:bamruinfo)
    @left_txt  = quote
    erb :bamruinfo
  end

  get '/join.test' do
    @title     = "Joining BAMRU"
    @hdr_img   = "images/helo.jpg"
    @right_nav = right_nav(:join)
    @right_txt = quote
    erb :join
  end

  get '/sgallery.test' do
    @title     = "BAMRU Photo Gallery"
    @hdr_img   = "images/hills.jpg"
    @right_nav = right_nav(:sgallery)
    @right_txt = PHOTO_RIGHT
    @left_txt  = PHOTO_LEFT
    erb :sgallery
  end

  get '/meeting_locations.test' do
    @title     = "BAMRU Meeting Location"
    @hdr_img   = "images/mtn_2.jpg"
    @right_nav = right_nav(:meeting_locations)
    @right_txt = quote
    erb :meeting_locations
  end

  get '/sarlinks.test' do
    @title     = "Links to SAR-related sites"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = right_nav(:sarlinks)
    @right_txt = quote
    erb :sarlinks
  end

  get '/donate.test' do
    @title     = "Donate to BAMRU"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = right_nav(:donate)
    @right_txt = quote
    erb :donate
  end

  get '/contact.test' do
    @title     = "BAMRU Contacts"
    @hdr_img   = "images/HawthornLZ.jpg"
    @right_nav = right_nav(:contact)
    @right_txt = quote
    erb :contact
  end

  get '/calendar.ical' do
    response["Content-Type"] = "text/plain"
    @actions = Action.all
    erb :export_ical, :layout => false
  end

  get '/calendar.csv' do
    response["Content-Type"] = "text/plain"
    @actions = Action.all
    erb :export_csv, :layout => false
  end

  # ----- ADMIN PAGES -----

  get '/admin' do
    erb :admin, :layout => :admin_layout
  end

  get '/admin_show' do
    # select start / finish dates
    @start  = Action.date_parse(select_start_date)
    @finish = Action.date_parse(select_finish_date)
    @start, @finish = @finish, @start if @finish < @start
    # remember start/finish dates by saving them in the session
    session[:start] = @start
    session[:finish] = @finish
    erb :admin_show, :layout => :admin_layout
  end

  get '/admin_new' do
    @action      = Action.new
    @post_action = "/admin_create"
    @button_text = "Create Action"
    erb :admin_new, :layout => :admin_layout
  end

  get '/admin_copy/:id' do
    @action      = Action.find_by_id(params[:id])
    @post_action = "/admin_create"
    @button_text = "Create Action"
    erb :admin_new, :layout => :admin_layout
  end

  post '/admin_create' do
    params.delete "submit"
    action = Action.new(params)
    if action.save
      set_flash_notice("Created New Action (#{action.kind.capitalize} > #{action.title} > #{action.start})")
      redirect '/admin_show'
    else
      set_flash_error("<u>Input Error(s) - Please Try Again</u><br/>#{error_text(action.errors)}")
      @action      = action
      @post_action = "/admin_create"
      @button_text = "Create Action"
      erb :admin_new, :layout => :admin_layout
    end
  end

  get '/admin_edit/:id' do
    @action      = Action.find_by_id(params[:id])
    @post_action = "/admin_update/#{params[:id]}"
    @button_text = "Update Action"
    erb :admin_edit, :layout => :admin_layout
  end

  post '/admin_update/:id' do
    action = Action.find_by_id(params[:id])
    params.delete "submit"
    if action.update_attributes(params)
      set_flash_notice("Updated Action (#{action.kind.capitalize} > #{action.title} > #{action.start})")
      redirect '/admin_show'
    else
      set_flash_error("<u>Input Error(s) - Please Try Again</u><br/>#{error_text(action.errors)}")
      @action      = action
      @post_action = "/admin_create"
      @button_text = "Update Action"
      erb :admin_edit, :layout => :admin_layout
    end

  end

  get '/admin_delete/:id' do
    action = Action.find_by_id(params[:id])
    set_flash_notice("Deleted Action (#{action.kind.capitalize} > #{action.title} > #{action.start})")
    action.destroy
    redirect "/admin_show"
  end

  get '/admin_load_csv' do
    erb :admin_load_csv, :layout => :admin_layout
  end

  post('/admin_load_csv') do
    if params[:file].nil?
      set_flash_error("Error - no CSV file was selected")
      redirect '/admin_load_csv'
    end
    File.open(MARSHALL_FILENAME, 'w') {|f| f.write params[:file][:tempfile].read}
    csv_load = CsvLoader.new(MARSHALL_FILENAME)
    set_flash_error(csv_load.error_message) if csv_load.has_errors?
    set_flash_notice(csv_load.success_message)
    redirect('/admin_show')
  end
  
  get '/malformed_csv' do
    response["Content-Type"] = "text/plain"
    File.read(MALFORMED_FILENAME)
  end

  get '/invalid_csv' do
    response["Content-Type"] = "text/plain"
    File.read(INVALID_FILENAME)
  end

  not_found do
    @right_nav = quote
    @hdr_img   = "images/mtn.jpg"
    erb :not_found
  end

end
