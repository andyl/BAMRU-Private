class Chat2Decorator < ApplicationDecorator
  decorates :chat

  def mobile_json
    fields = ["id", "text"]
    hash = subset(model.attributes, fields)
    hash[:created_at] = model.created_at.strftime("%H:%M") if model.created_at
    hash[:short_name] = model.member.short_name            if model.member
    hash.to_json
  end

  def self.mobile_json
    chat_set = Chat.order('id DESC').limit(15).all.reverse
    result = chat_set.map do |m|
      Chat2Decorator.new(m).mobile_json
    end.join(',')
    "[#{result}]"
  end

end