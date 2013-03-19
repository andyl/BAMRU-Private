# see http://railscasts.com/episodes/219-active-model
# see http://railscasts.com/episodes/326-activeattr
# see https://github.com/6twenty/modest_model

# This service is a 'front-end' to EventLink
# It presents a Backbone-compatible model that coordinates
# data-elements from Event, DataLink and EventLink

class EventLinkSvc < ModestModel::Base

  def self.cfg_params(event_link_object)
      el = event_link_object
      dl = event_link_object.data_link
      {
        "id"              => el.id,
        "caption"         => dl.try(:caption),
        "member_id"       => dl.member_id,
        "site_url"        => dl.site_url,
        "backup_url"      => dl.backup_url,
        "updated_at"      => [el.updated_at, dl.updated_at].max
      }
  end

  attributes :member_id, :caption     # DataLink attributes
  attributes :updated_at              # DataLink attributes
  attributes :site_url, :backup_url   # DataLink attributes
  attributes :id                      # EventLink attributes
  attributes :event_id                # Event attributes

  # ----- validations -----

  validates_presence_of :event_id, :member_id

  # ----- public instance methods -----

  def save
    if new_record?
      create
    else
      image_file.update_attributes(caption: self.caption)
    end
  end

  def update_attributes(attributes)
    assign_attributes(attributes)
    save
  end

  def destroy
    return if new_record?
    data_link.destroy unless multiple_event_links?
    event_link.destroy
  end

  def new_record?
    ! self.id?
  end

  # ----- associations -----

  def event
    event_link.event
  end

  def event_link
    @event_link ||= EventLink.find(self.id)
  end

  def event_links
    event.event_links
  end

  def data_link
    @data_link ||= event_link.data_link
  end

  def data_links
    event.data_links
  end

  # ----- public class methods -----

  def self.create(attributes)
    obj = self.new(attributes)
    obj.save
    obj
  end

  def self.find(event_link_id)
    service_object(EventLink.find(event_link_id))
  end

  def self.find_by_event(event_id)
    event = Event.find(event_id)
    event.event_links.map { |ef_obj| service_object(ef_obj) }
  end

  private

  # ----- private instance methods -----

  def create
    assign_attributes self.class.cfg_params(create_event_link_object)
  end

  def create_event_link_object
    dp_obj = create_data_link_object
    opts = {
        data_link_id: dp_obj.id,
        event_id:     self.event_id,
    }
    EventLink.create opts
  end

  def create_data_link_object
    dl = DataLink.create(site_url: self.site_url, member_id: self.member_id, caption: self.caption)
    dl.generate_backup
    dl
  end

  def assign_attributes(attrs)
    attrs.each do |key, val|
      send "#{key}=", val
    end unless attrs.blank?
  end

  def multiple_event_links?
    df_id = event_link.data_link_id
    EventLink.where(data_link_id: df_id).count > 1
  end

  # ----- private class methods -----

  def self.service_object(event_link_obj)
    new(cfg_params(event_link_obj))
  end

end

