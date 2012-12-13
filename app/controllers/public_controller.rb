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

end
