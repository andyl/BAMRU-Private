class InboundMailsController < ApplicationController

  before_filter :authenticate_member_with_basic_auth!

  def index
    @inbound_mails = InboundMail.order('id DESC').all
  end

  def show
    @mail = InboundMail.where(:id => params["id"]).first
  end

  def destroy
    @mail = InboundMail.where(:id => params["id"]).first
    @mail.destroy
    redirect_to inbound_mails_path, :notice => "InboundMail was Deleted"
  end

end