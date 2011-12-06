class DistributionDecorator < ApplicationDecorator
  decorates :distribution

  def mobile_json
    fields = ["id", "message_id", "member_id", "read", "rsvp_answer"]
    hash = subset(model.attributes, fields)
    hash.to_json
  end

  def self.mobile_json(id = nil)
    msg_top_ten = Message.select(:id).order('id DESC').limit(10)
    distribution_set = Distribution.where(:message_id => msg_top_ten).all
    result = distribution_set.map do |m|
      DistributionDecorator.new(m).mobile_json
    end.join(',')
    "[#{result}]"
  end

end