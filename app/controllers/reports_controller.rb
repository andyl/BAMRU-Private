class ReportsController < ApplicationController

  #before_filter :authenticate_member!
  before_filter :authenticate_member_with_basic_auth!
  #before_filter :gdocs_oauth_setup, :except => [:index, :show, :show_current_report, :show_historical_report]

  def index
    @current_report_list    = current_report_list
    @historical_report_list = historical_report_list
  end

  # router regex /creports/:title
  # invoke using /creports/BAMRU-roster.html
  def show_current_report
    @members   = Member.active.order_by_last_name
    @memreg    = Member.registered.order_by_last_name
    args = {:layout => nil, :formats => [params[:format]]}
    render "_c_#{params[:title]}", args
  end

  # router regex /preports/:period_id/:title
  # invoke using /preports/234/DO-report.pdf
  def show_period_report
    @period_id = params[:period_id]
    args = {:layout => nil}
    render "_p_#{params[:title]}.#{params[:format]}", args
  end

  # router regex /hreports/:title
  # invoke using /hreports/MRA.html?start=2011-02&finish=2012-03&member_id=23
  def show_historical_report
    @start   = params[:start]
    @finish  = params[:finish]
    @user_id = params[:user_id]
    @title   = params[:title]
    @rsvc    = eval("Report#{@title}Svc").new(@start, @finish)
    args = {:layout => nil}
    render "_h_#{@title}.#{params[:format]}", args
  end

  #def gdocs_show
  #  title, format = save_params_to_session(params)
  #  if @access_token
  #    tlist = 'https://docs.google.com/feeds/documents/private/full'
  #    args = {:layout => nil}
  #    doc_name = title + '.' + format
  #    doc_time = Time.now.strftime("%Y-%m-%d_%H%M")
  #    doc_slug = "#{title} #{doc_time}"
  #    session[:doc_slug] = doc_slug
  #    ctype    = cx_type(format)
  #    @members = Member.registered.order_by_last_name.all
  #    doc_body = render_to_string(doc_name, args)
  #    response = @access_token.post(tlist, doc_body, {'Slug' => "#{doc_slug}", 'Content-Type' => ctype})
  #    if response.is_a?(Net::HTTPSuccess)
  #      redirect_to '/reports/gdocs/uploading'
  #    else
  #      redirect_to "/reports", :alert => "unsuccessful request: #{response.inspect}"
  #    end
  #  else
  #    redirect_to '/reports/gdocs/request'
  #  end
  #end
  #
  #def gdocs_request
  #  cb = "#{request.scheme}://#{request.host}:#{request.port}/reports/gdocs/auth"
  #  @request_token = @consumer.get_request_token(:oauth_callback => cb)
  #  session[:oauth][:request_token]        = @request_token.token
  #  session[:oauth][:request_token_secret] = @request_token.secret
  #  redirect_to @request_token.authorize_url
  #end
  #
  #def gdocs_auth
  #  @access_token = @request_token.get_access_token :oauth_verifier => params[:oauth_verifier]
  #  session[:oauth][:access_token]        = @access_token.token
  #  session[:oauth][:access_token_secret] = @access_token.secret
  #  redirect_to "/reports/gdocs/show"
  #end
  #
  #def gdocs_uploading
  #  @doc_slug = session[:doc_slug]
  #  session[:doc_slug] = nil
  #  session[:title]    = nil
  #  session[:format]   = nil
  #end

  protected

  # report_type, report_name, report_file, report_description
  def current_report_list
    [
      ["Roster",  "Map List",          'BAMRU-roster.html',         "HTML Roster with Gmap links"],
      ["Roster",  "CSV Report",        'BAMRU-roster.csv',          "For importing into Excel"],
      ["Roster",  "CSV Report (SMSO)", 'BAMRU-roster-smso.csv',     "CSV formatted for SMSO"],
      ["Roster",  "VCF Report",        'BAMRU-roster.vcf',          "VCARD for importing into Gmail & Outlook"],
      ["Roster",  "BAMRU Full",        'BAMRU-full.pdf',            "BAMRU roster with full contact info"],
      ["Roster",  "BAMRU Field",       'BAMRU-field.pdf',           "One page roster with basic contact info"],
      ["Roster",  "BAMRU Wallet",      'BAMRU-wallet.pdf',          "A credit-card sized roster for your wallet"],
      ["Misc",    "BAMRU Names",       'BAMRU-names.pdf',           "List of names for ProDeal reporting"],
      ["Misc",    "BAMRU Labels",      'BAMRU-labels.pdf',          "Mailing labels with member home address"],
      ["Paging",  "Response Times",    'Paging-ResponseTimes.pdf',  "Shows response times from recent pages"],
      ["Certs",   "Cert Full Export",  'BAMRU-CertAll.pdf',         "All member certifications [runs slow]"],
      ["Certs",   "Cert Expiration",   'BAMRU-CertExpiration.pdf',  "Expired certifications"]
    ]
  end

  # report_name, report_description, show_name_picker
  def historical_report_list
    [
      ["MRA",      "MRA Report",                 false],
      ["Detail",   "Unit-wide Activity Detail",  false],
      #["Activity", "Member Activity Detail",     true]
    ]
  end

  def cx_type(format)
    case format.upcase
      when "XLS"  then 'application/vnd.ms-excel'
      when "PDF"  then 'application/pdf'
      when "CSV"  then 'text/csv'
      when "VCF"  then 'text/plain'
      when "HTML" then "text/html"
      else "text/plain"
    end
  end
  
  def save_params_to_session(params)
    title = params[:title]   || session[:title]
    format = params[:format] || session[:format]
    session[:title]  = title
    session[:format] = format
    [title, format]
  end

  #def gdocs_oauth_setup
  #
  #  session[:oauth] ||= {}
  #
  #  consumer_key    = GOOGLE_CONSUMER_KEY
  #  consumer_secret = GOOGLE_CONSUMER_SECRET
  #
  #  @scope = 'https://docs.google.com/feeds'
  #  @consumer ||= OAuth::Consumer.new(consumer_key, consumer_secret, {
  #    :site               => "https://www.google.com",
  #    :request_token_path => "/accounts/OAuthGetRequestToken?scope=#{@scope}",
  #    :access_token_path  => '/accounts/OAuthGetAccessToken',
  #    :authorize_path     => '/accounts/OAuthAuthorizeToken'
  #  })
  #  # @consumer.http.set_debug_output($stdout)
  #
  #  req_token         = session[:oauth][:request_token]
  #  req_token_secret  = session[:oauth][:request_token_secret]
  #  acc_token         = session[:oauth][:access_token]
  #  acc_token_secret  = session[:oauth][:access_token_secret]
  #
  #  unless req_token.nil? || req_token_secret.nil?
  #    @request_token = OAuth::RequestToken.new(@consumer, req_token, req_token_secret)
  #  end
  #
  #  unless acc_token.nil? || acc_token_secret.nil?
  #    @access_token = OAuth::AccessToken.new(@consumer, acc_token, acc_token_secret)
  #  end
  #
  #end

end

