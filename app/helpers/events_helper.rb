module EventsHelper

  def event_range_select(start, finish, direction, scope = Event)
    if direction == "start"
      opt  = start.to_label
    else
      opt  = finish.to_label
    end
    opts = scope.range_array(opt)
    output = "<select name='#{direction}'>#{opt}"
    output << opts.map do |x|
      sel = x == opt ? " SELECTED" : ""
      "<option value='#{x}'#{sel}>#{x}"
    end.join unless opts.nil?
    output << "</select>"
    output
  end

  def bb_json(event)
    fields = %w(typ published title leader location lat lon start finish all_day description)
    field_map = fields.map do |field|
      value = event.send(field.to_s)
      value = value.last_name if value.is_a?(Member)
      if %w(start finish).include?(field)
        value = value.try(:strftime, "%Y-%m-%d %H:%M")
      end
      %Q("#{field}":"#{value}")
    end
    body = field_map.join(',')
    "{#{body}}"
  end

end

require 'time'

class Time
  def to_label
    strftime "%b-%Y"
  end
end
