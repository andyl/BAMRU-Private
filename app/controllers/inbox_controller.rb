class InboxController < ApplicationController

  before_filter :authenticate_member!

  def index
    @member = Member.where(:id => params['member_id']).first
    @dists  = @member.distributions.order('id DESC')
  end
  
end
