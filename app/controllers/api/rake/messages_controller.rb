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
  
  ## curl -u <first>_<last>:<pwd> http://server/api/rake/messages/render?address=<address>
  #def render_notice
  #  count = params[:count]
  #  msg = "#{params[:label]} #{count} addresses"
  #  ActiveSupport::Notifications.instrument("rake.message.render", {:text => msg}) unless count.blank?
  #  render(:json => "OK\n")
  #end
  #
  ## curl -u <first>_<last>:<pwd> http://server/api/rake/messages/<id>/sent_at_now.json
  #def sent_at_now
  #  id = params[:id]
  #  @om = OutboundMail.find id
  #  member = @om.distribution.member
  #  if params[:update] == "true"
  #    @om.update_attributes(:sent_at => Time.now) unless @om.nil?  || ! @om.sent_at.nil?
  #  end
  #  ActiveSupport::Notifications.instrument("rake.message.send", {:member => member, :text => "#{@om.address}-#{@om.label}"})
  #  render :json => "OK\n"
  #end
  #
  ## curl -X POST -u <first>_<last>:<pwd> http://server/api/rake/messages/record_sent_at
  #def update_sent_at
  #  unless (data = params[:data]).blank?
  #    clean_data = URI.unescape(data)
  #    update_list = clean_data.split("\n").map do |value|
  #      id, time = value.split('|')
  #      [OutboundMail.find(id), Time.parse(time)]
  #    end
  #    update_list.each do |item|
  #      outbound_mail, time = item
  #      outbound_mail.update_column(:sent_at, time)
  #    end
  #    ActiveSupport::Notifications.instrument("rake.messages.send", {:text => "update sent_at: #{update_list.length} records"})
  #  end
  #
  #  render :json => "OK\n"
  #end

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
    ActiveSupport::Notifications.instrument("rake.messages.load", {:text => "records: #{count}"})
    render :json => "OK (records: #{count})\n"
  end

end
