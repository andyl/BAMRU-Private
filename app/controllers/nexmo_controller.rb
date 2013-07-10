class NexmoController < ApplicationController

  def inbound
    NexmoInboundSvc.new(params).load
    render text: "OK", layout: false
  end

end