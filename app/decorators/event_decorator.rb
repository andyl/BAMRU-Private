class EventDecorator < ApplicationDecorator
  decorates :event

  def mobile_json
    member_fields = %w(id typ first_name last_name)
    result = subset(model.attributes, member_fields)
    result["full_roles"]          = model.full_roles
    result["phones_attributes"]   = phone_data    if has_phone?
    result["emails_attributes"]   = email_data    if has_email?
    result["contacts_attributes"] = contacts_data if has_contacts?
    result["photo"]               = "true"        if has_photo?
    result.to_json
  end


  def backbone_json
    fields = ["id", "typ", "title", "location"]
    results = subset(model.attributes, fields)
    results["start"] = model.start.strftime("%Y-%m-%d")
    results["photo"] = photos.first.thumbnail_url if false # if has_photo?
    results.to_json
  end

  def self.signin_meetings
    meetings = Event.current_meetings.all
    result   = meetings.map do |meet|
      EventDecorator.new(meet).backbone_json
    end.join(',')
    "[#{result}]"
  end

end