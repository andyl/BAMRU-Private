class EventDecorator < ApplicationDecorator
  decorates :event

  def backbone_json
    fields = ["id", "title", "start_date", "location"]
    hash = subset(model.attributes, fields)
    hash.to_json
  end

  def self.current_meetings
    meetings = Event.current_meetings.all
    result   = meetings.map do |meet|
      EventDecorator.new(meet).backbone_json
    end.join(',')
    "[#{result}]"
  end

end