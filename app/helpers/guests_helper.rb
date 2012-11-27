module GuestsHelper

  def last_event_link(guest)
    last_event = guest.events.order('start').last
    return "" if last_event.blank?
    label = last_event.start.strftime("%Y-%m-%d")
    target = "/events/#{last_event.id}/roster"
    "<a href='#{target}'>#{label}</a>"
  end

  def show_event(event)
    label = "#{event.start.strftime("%Y-%m-%d")} <b>#{event.title}</b> @ #{event.location}"
    href  = "/events/#{event.id}/roster"
    "<a href='#{href}'>#{label}</a><br/>"
  end

  def show_events(events)
    events.map {|event| show_event(event)}.join
  end

  def guest_icon(guest)
    photo = guest.photo_icon
    return "" if photo.empty?
    "<img style='height:23px;width:30px;display:block;margin:0;padding:0;' src='#{photo}'/>"
  end

end

