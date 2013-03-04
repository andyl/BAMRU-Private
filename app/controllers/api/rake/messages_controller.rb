class Api::Rake::MessagesController < ApplicationController

  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  skip_before_filter :verify_authenticity_token

  # curl -u <first>_<last>:<pwd> http://server/api/rake/messages.json
  def index
    @mails = OutboundMail.pending.all
    render :json => @mails.to_json
  end

  # curl -u <first>_<last>:<pwd> http://server/api/rake/messages/count.json
  def pending_count
    count = OutboundMail.pending.count
    render :json => count
  end
  
 # curl -u <first>_<last>:<pwd> http://server/api/rake/messages/load_inbound.json
 def load_inbound
    count = InboundMailSvc.new.load_inbound
    ActiveSupport::Notifications.instrument("rake.messages.load", {:text => "records: #{count}"})
    render :json => "OK (records: #{count})\n"
 end

end
