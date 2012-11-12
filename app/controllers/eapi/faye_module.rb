module Eapi::FayeModule

  def broadcast(action, model = nil)
    %w(event controller action).each { |x| params.delete(x) }
    participant_id = params["id"]
    msg = {
        action: action,
        params: params,
        modelid: model.try(:id) || params[:id],
        sessionid: session["session_id"],
        userid: current_member.id
    }
    strip_model = ->(model) { model.split('/')[0..-2].join('/') }
    channel = action == "add" ? request.path : strip_model.call(request.path)
    publish_faye_message(channel, msg.to_json)
  end

  def publish_faye_message(channel, string)
    message = {:channel => channel, :data => string}
    uri = URI.parse("#{FAYE_SERVER}/faye")
    status = Net::HTTP.post_form(uri, :message => message.to_json)
  end

end