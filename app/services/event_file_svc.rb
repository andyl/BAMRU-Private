# see http://railscasts.com/episodes/219-active-model
# see http://railscasts.com/episodes/326-activeattr
# see https://github.com/6twenty/modest_model

# This service is a 'front-end' to EventFile
# It presents a Backbone-compatible model that coordinates
# data-elements from Event, DataFile and EventFile

class EventFileSvc < ModestModel::Base

  attributes :id                          # EventFile attributes
  attributes :member_id, :data, :caption  # DataFile attributes
  attributes :event_id                    # Event attributes
  attributes :filepath                    # test helper...

  # ----- validations -----

  validates_presence_of :event_id, :member_id

  # ----- public instance methods -----

  def save
    if new_record?
      create
    else
      data_file.update_attributes(caption: self.caption)
    end
  end

  def update_attributes(attributes)
    assign_attributes(attributes)
    save
  end

  def destroy
    return if new_record?
    data_file.destroy unless multiple_event_files?
    event_file.destroy
  end

  def new_record?
    ! self.id?
  end

  # ----- associations -----

  def event
    event_file.event
  end

  def event_file
    @event_file ||= EventFile.find(self.id)
  end

  def event_files
    event.event_files
  end

  def data_file
    @data_file ||= event_file.data_file
  end

  def data_files
    event.data_files
  end

  # ----- public class methods -----

  def self.create(attributes)
    obj = self.new(attributes)
    obj.save
    obj
  end

  def self.find(event_file_id)
    service_object(EventFile.find(event_file_id))
  end

  def self.find_by_event(event_id)
    event = Event.find(event_id)
    event.event_files.map { |ef_obj| service_object(ef_obj) }
  end

  private

  # ----- private instance methods -----

  def create
    ef = create_event_file_object
    self.id = ef.id
  end

  def create_event_file_object
    df_obj = create_data_file_object
    opts = {
        data_file_id: df_obj.id,
        event_id:     self.event_id,
        caption:      self.caption
    }
    EventFile.create opts
  end

  def create_data_file_object
    DataFile.create(data: self.data || File.new(self.filepath), member_id: self.member_id, caption: self.caption)
  end

  def assign_attributes(attrs)
    attrs.each do |key, val|
      send "#{key}=", val
    end unless attrs.blank?
  end

  def multiple_event_files?
    df_id = event_file.data_file_id
    EventFile.where(data_file_id: df_id).count > 1
  end

  # ----- private class methods -----

  def self.service_params(event_file_obj)
    {
      "id"        => event_file_obj.id,
      "caption"   => event_file_obj.data_file.caption,
      "member_id" => event_file_obj.data_file.member_id
    }
  end

  def self.service_object(event_file_obj)
    new(service_params(event_file_obj))
  end

end

