class Api::Rake::MessagesController < ApplicationController

  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/api/rake/messages.json
  def index
    @mails = OutboundMail.pending.all
    render :json => @mails.to_json
  end

  # curl -u <first>_<last>:<pwd> http://server/api/rake/messages/<id>/sent_at_now.json
  def sent_at_now
    id = params[:id]
    @om = OutboundMail.find id
    @om.update_attributes(:sent_at => Time.now) unless @om.nil?  || ! @om.sent_at.nil?
    render :json => "OK\n"
  end

  # curl -u <first>_<last>:<pwd> http://server/api/rake/messages/load_inbound.json
  def load_inbound
    dir = Rails.root.to_s + "/tmp/inbound_mails"
    count = 0
    Dir.glob(dir + '/*').each do |file|
      count += 1
      opts   = YAML.load(File.read(file))
      InboundMail.create_from_opts(opts)
      system "rm #{file}"
    end
    render :json => "OK (records: #{count})\n"
  end

end
