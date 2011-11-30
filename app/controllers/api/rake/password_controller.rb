require "message_params"

class Api::Rake::PasswordController < ApplicationController

  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/api/rake/password/forgot.json?address=xyz@corp.com
  def reset
    adr     = params['address']
    email   = Email.where("lower(address) like ?", adr.downcase).try(:first)
    member  = email.try(:member)
    hash    = MessageParams.password_reset(member, adr)
    message = Message.create(hash)
    message.create_all_outbound_mails
    ActiveSupport::Notifications.instrument("rake.password.reset", {:member => member, :text => "email: #{adr}"})
    render :json => "OK\n"
  end

end
