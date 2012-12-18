require File.expand_path("../../../config/environment", __FILE__)
require 'gcal4ruby'
require 'yaml'

class QcGcal

  include GCal4Ruby

  # ----- Utility Methods -----

  def self.get_current_events_from_database
    ::Event.between(::Event.default_start, ::Event.default_end)
  end

  def self.authenticate_and_return_gcal_service
    gcal_service = Service.new
    gcal_service.authenticate(GCAL_USER, GCAL_PASS)
    gcal_service
  end

  def self.save_event_to_gcal(gcal_service, gcal_event, ar_event)
    return puts("CAN'T SAVE OPERATIONS") if ar_event.typ == "operation"
    gcal_event.calendar    = gcal_service.calendars.first
    gcal_event.title       = ar_event.title
    gcal_event.start_time  = ar_event.gcal_start
    gcal_event.end_time    = ar_event.gcal_finish
    gcal_event.all_day     = ar_event.gcal_all_day?
    gcal_event.content     = ar_event.gcal_content
    gcal_event.where       = ar_event.gcal_location
    gcal_event.save
  end

  def self.count_gcal_events
    service = authenticate_and_return_gcal_service
    cal     = service.calendars.first
    cal.events.length
  end

  # ----- Batch Sync Functions -----
  # - called by command-line tool to completely resync the calendars

  def self.delete_all_gcal_events
    service = authenticate_and_return_gcal_service
    cal     = service.calendars.first
    cal.events.each do |event|
      puts "Deleting #{event.title}"
      event.delete
    end
    "OK"
  end

  def self.add_all_current_events_to_gcal
    service = authenticate_and_return_gcal_service
    get_current_events_from_database.each do |ar_event|
      if ar_event.typ != "operation"
        puts "Adding #{ar_event.title} (#{ar_event.id})"
        event = ::Event.new(service)
        save_event_to_gcal(service, event, ar_event)
      end
    end
    "OK"
  end

  def self.sync
    2.times { delete_all_gcal_events }
    add_all_current_events_to_gcal
  end

  # ----- Event-Driven Sync Functions -----
  # - called by WebApp during CRUD operations

  def self.create_event_id(event_id)
    event = ::Event.find(event_id)
    create_event event
  end

  def self.create_event(ar_event)
    return puts("can't create operation") if ar_event.typ == "operation"
    gcal_service = authenticate_and_return_gcal_service
    gcal_event   = Event.new(gcal_service)
    puts "Creating gCal Event id:#{ar_event.id}"
    save_event_to_gcal(gcal_service, gcal_event, ar_event)
  end

  def self.update_event_id(id)
    update_event ::Event.find(id)
  end

  def self.update_event(action)
    return puts("can't update operation") if action.typ == "operation"
    delete_event(action.id)
    create_event(action)
  end

  def self.delete_event(id)
    gcal_service = authenticate_and_return_gcal_service
    gcal_events  = Event.find(gcal_service, "BE#{id}")
    gcal_events.each {|ev| puts "Creating gCal Event id:#{id}" ; ev.delete }
  end

end