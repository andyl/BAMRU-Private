# see http://railscasts.com/episodes/219-active-model
# see http://railscasts.com/episodes/326-activeattr
# see https://github.com/6twenty/modest_model

# This service is a 'front-end' to EventPhoto
# It presents a Backbone-compatible model that coordinates
# data-elements from Event, DataPhoto and EventPhoto

class EventPhotoSvc < ModestModel::Base

  def self.cfg_params(event_photo_object)
      ep = event_photo_object
      dp = event_photo_object.data_photo
      {
        "id"              => ep.id,
        "caption"         => dp.try(:caption),
        "member_id"       => dp.member_id,
        "image_url"       => dp.image.url,
        "icon_url"        => dp.icon_url,
        "original_url"    => dp.original_url,
        "image_file_name" => dp.image_file_name,
        "updated_at"      => [ep.updated_at, dp.updated_at].max
      }
  end

  attributes :member_id, :image, :image_url, :caption   # DataPhoto attributes
  attributes :image_file_name, :updated_at              # DataPhoto attributes
  attributes :icon_url, :original_url                   # DataPhoto attributes
  attributes :id                                        # EventPhoto attributes
  attributes :event_id                                  # Event attributes
  attributes :filepath                                  # test helper...

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
    data_photo.destroy unless multiple_event_photos?
    event_photo.destroy
  end

  def new_record?
    ! self.id?
  end

  # ----- associations -----

  def event
    event_photo.event
  end

  def event_photo
    @event_photo ||= EventPhoto.find(self.id)
  end

  def event_photos
    event.event_photos
  end

  def data_photo
    @data_photo ||= event_photo.data_photo
  end

  def data_photos
    event.data_photos
  end

  # ----- public class methods -----

  def self.create(attributes)
    obj = self.new(attributes)
    obj.save
    obj
  end

  def self.find(event_photo_id)
    service_object(EventPhoto.find(event_photo_id))
  end

  def self.find_by_event(event_id)
    event = Event.find(event_id)
    event.event_photos.map { |ef_obj| service_object(ef_obj) }
  end

  private

  # ----- private instance methods -----

  def create
    assign_attributes self.class.cfg_params(create_event_photo_object)
  end

  def create_event_photo_object
    dp_obj = create_data_photo_object
    opts = {
        data_photo_id: dp_obj.id,
        event_id:     self.event_id,
    }
    EventPhoto.create opts
  end

  def create_data_photo_object
    DataPhoto.create(image: self.image || File.new(self.filepath), member_id: self.member_id, caption: self.caption)
  end

  def assign_attributes(attrs)
    attrs.each do |key, val|
      send "#{key}=", val
    end unless attrs.blank?
  end

  def multiple_event_photos?
    df_id = event_photo.data_photo_id
    EventPhoto.where(data_photo_id: df_id).count > 1
  end

  # ----- private class methods -----

  def self.service_object(event_photo_obj)
    new(cfg_params(event_photo_obj))
  end

end

