class Api::MailsController < ApplicationController

  respond_to :xml, :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/api/mails.json
  def index
    @mails = OutboundMail.pending.all
    respond_with(@mails)
  end

  # curl -u <first>_<last>:<pwd> http://server/api/mails/<id>/sent_at_now.json
  def sent_at_now
    id = params[:id]
    @om = OutboundMail.find id
    @om.update_attributes(:sent_at => Time.now) unless @om.nil?  || ! @om.sent_at.nil?
    render :json => "OK\n"
  end

  # curl -X POST -u <first>_<last>:<pwd> -d "<string>" http://server/api/mails/inbound.json
  def inbound
    @im = InboundMail.create_from_params(params[inbound])
    respond_with(@im) do |format|
      format.json { render :json => "OK\n"}
    end
  end

end
