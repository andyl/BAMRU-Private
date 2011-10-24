class Api::MailsController < ApplicationController

  respond_to :xml, :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/api/mails.json
  def index
    @mails = OutboundMail.pending.all
    respond_with(@mails)
  end

  # curl -u <first>_<last>:<pwd> http://server/api/mails/<id>.json
  def show
    id = params[:id].to_i
    @mail = OutboundMail.where(:id => id).first
    (render :text => "Not Found (#{id})"; return) if @mail.nil? || @mail.invalid?
    (render :text => "Already Sent (#{id})"; return) unless @mail.sent_at.blank?
    @mailing    = nil
    message    = @mail.distribution.message
    address    = @mail.email_address
    full_label = @mail.full_label
    dist       = @mail.distribution
    opts    = Notifier.set_optz(message, address, full_label, dist)
    @mailing = Notifier.process_email_message(opts) if @mail.email
    @mailing = Notifier.process_sms_message(opts)   if @mail.phone
    (render :text => "Bad eMail (#{id})"; return) if @mailing.nil?
    debugger
    respond_with(@mailing) do |format|
      format.json { render :json => @mailing.to_json }
    end
  end
end
