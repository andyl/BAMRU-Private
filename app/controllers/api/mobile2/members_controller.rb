class Mobile2::MembersController < ApplicationController

  respond_to :html, :json

  before_filter :authenticate_mobile_member!

  def index
    render :text => MemberDecorator.mobile_json,
           :content_type => "application/json"
  end

  def show
    id = params[:id]
    mem = Member.find(id)
    render :text => MemberDecorator.new(mem).mobile_json,
           :content_type => "application/json"
  end

end
