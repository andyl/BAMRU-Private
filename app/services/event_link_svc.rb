require 'ar_proxy'

class EventLinkSvc < ArProxy

  proxy_attributes(
    :@event_link => [:id, :updated_at, :event_id],
    :@data_link  => [:caption, :member_id, :site_url, :backup_url]
  )

  # ----- associations -----

  def event;       event_link.event;  end
  def event_links; event.event_links; end
  def data_links;  event.data_links;  end

  # ----- validations -----

  validates_presence_of :event_id, :member_id

  def initialize(params = {})
    @data_link  = DataLink.new
    @event_link = EventLink.new
    assign_attributes(params)
  end

  # ----- instance methods -----

  def save
    @data_link.save
    @event_link.data_link_id = @data_link.id
    @event_link.save
  end

  def destroy
    data_link.destroy unless multiple_event_links?
    event_link.destroy
  end

  # ----- class methods -----

  def self.create(params)
    obj = self.new(params)
    obj.save
    obj.data_link.generate_backup
    obj
  end

  def self.find(id)
    el = EventLink.find(id)
    raise "NOT FOUND" if el.nil?
    dl  = el.data_link
    obj = self.new
    obj.event_link = el
    obj.data_link  = dl
    obj
  end

  def self.find_by_event(event_id)
    event = Event.find(event_id)
    event.event_links.map { |ef_obj| self.find(ef_obj.id) }
  end

  private

  def multiple_event_links?
    df_id = event_link.data_link_id
    EventLink.where(data_link_id: df_id).count > 1
  end

end
