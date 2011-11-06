class DistributionDecorator < ApplicationDecorator
  decorates :distribution

  def mobile_json
    fields = ["id", "message_id"]
    hash = subset(model.attributes, fields)
    hash.to_json
  end

  def self.mobile_json(id = nil)
    distribution_set = Distribution.order('id DESC').limit(15)
    distribution_set = distribution_set.where(:member_id => id) unless id.nil?
    result = distribution_set.map do |m|
      DistributionDecorator.new(m).mobile_json
    end.join(',')
    "[#{result}]"
  end

end