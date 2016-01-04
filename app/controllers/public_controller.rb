class PublicController < ApplicationController


  def index
  end

  def calendar
    @events = Event.published
    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(@events) }
      format.xls { send_data generate_csv(@events, col_sep: "\t")}
    end
  end

  def calendar2
    @events = Event.published
    respond_to do |format|
      format.html
      format.csv { send_data generate_csv2(@events) }
      format.xls { send_data generate_csv2(@events, col_sep: "\t")}
    end
  end

  private

  def generate_csv(events, options = {})
    require 'csv'
    labels = %w(kind title leaders start     finish     location lat lon description)
    fields = %w(typ  title leaders csv_start csv_finish location lat lon description)
    CSV.generate(options) do |csv|
      csv << labels
      events.each do |event|
        csv << fields.map { |f| event.send(f.to_sym) }
      end
    end
  end

  # Header Fields - kind, title, leaders, start_date, finish_date, start_time, finish_time, location, lat, lon, description
  # start_date and finish_date will have the same format as current CSV
  # start_time and finish_time will be formatted as HHMM / zero padded / pacific time
  # for all-day events, start_time and finish_time will be blank

  def generate_csv2(events, options = {})
    require 'csv'
    labels = %w(kind title leaders begin_date     begin_time     finish_date     finish_time    location lat lon description)
    fields = %w(typ  title leaders csv_start_date csv_start_time csv_finish_date csv_start_time location lat lon description)
    CSV.generate(options) do |csv|
      csv << labels
      events.each do |event|
        csv << fields.map { |f| event.send(f.to_sym) }
      end
    end
  end
end
