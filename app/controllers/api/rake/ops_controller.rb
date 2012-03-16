class Api::Rake::OpsController < ApplicationController

  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/api/rake/ops/set_do.json
  def set_do
    Member.set_do
    name = Member.current_do.first.last_name
    ActiveSupport::Notifications.instrument("rake.ops.set_do", {:text => "current do: #{name}"})
    render :json => "OK (current do: #{name})\n"
  end

  # curl -u <first>_<last>:<pwd> http://server/api/rake/ops/message_cleanup.json
  def message_cleanup
    storage_limit = 100
    purge_count   = 0
    Message.order('id DESC').all.each_with_index do |msg, index|
      if index >= storage_limit
        msg.destroy
        purge_count += 1
      end
    end
    ActiveSupport::Notifications.instrument("rake.ops.message_cleanup", {:text => "records purged: #{purge_count}"})
    render :json => "OK (records purged: #{purge_count})\n"
  end

  # curl -u <first>_<last>:<pwd> http://server/api/rake/ops/avail_op_cleanup.json
  def avail_op_cleanup
    records = AvailOp.older_than_this_month.all
    purge_count = records.length
    records.each { |rec| rec.destroy }
    ActiveSupport::Notifications.instrument("rake.ops.avail_op_cleanup", {:text => "records purged: #{purge_count}"})
    render :json => "OK (records purged: #{purge_count})\n"
  end

end
