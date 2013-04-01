class SubscriptionController < ApplicationController

  before_filter :authenticate_member!

  def set
    event = params[:event]
    role  = params[:role]
    AlertSubscription.create_for(event, role)
    render text: "Created #{event}/#{role}"
  end

  def del
    event = params[:event]
    role  = params[:role]
    AlertSubscription.destroy_all(event, role)
    render text: "Deleted #{event}/#{role}"
  end

end