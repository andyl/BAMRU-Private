module MessagesHelper
  def span_wrap(value, color = "white")
    padding = "3px"
    "<span style='background-color: #{color}; padding-left: #{padding}; padding-right: #{padding};'>#{value}</span>"
  end

  def response_time_display(message)
    count = message.distributions.count
    read15  = @message.distributions.response_less_than(60*15).count
    read60  = @message.distributions.response_less_than(60*60).count
    read120 = @message.distributions.response_less_than(60*120).count
    pct15   = ((read15 * 100) / count).to_i
    pct60   = ((read60 * 100) / count).to_i
    pct120  = ((read120 * 100) / count).to_i
    min15   =  "#{pct15}% in 15min"
    min60   =  "#{pct60}% in 60min"
    min120  =  "#{pct120}% in 120min"
    [min15, min60, min120].join(", ")
  end

  def rsvp_display(message)
    return "NA" unless message.rsvp
    num_yes  = message.distributions.rsvp_yes.count
    num_no   = message.distributions.rsvp_no.count
    num_none = message.distributions.rsvp_none.count
    "Yes #{num_yes}, No #{num_no}, NONE #{num_none}"
  end

  def sent_display(count, message)
    color = case
      when message.has_open_bounce? : "lightpink"
      when message.has_fixed_bounce? : "#ccffff"
      else
        "white"
    end
    span_wrap(count, color)
  end

  def bounce_display(count)
    color = count == 0 ? "while" : "lightpink"
    span_wrap(count, color)
  end

  def read_display(sent, read)
    color = sent != read ? "lightyellow" : "white"
    span_wrap(read, color)
  end

  def yes_no(boolean_value)
    boolean_value == true ? "yes" : "no"
  end

  def yes_no_bounce(distribution)
    v1 = "<span style='padding-left: 3px; padding-right: 3px; background-color: lightpink;'>yes</span>"
    v2 = "<span style='padding-left: 3px; padding-right: 3px; background-color: #ccffff;'>no</span>"
    v3 = "no"
    return v1 if distribution.has_open_bounce?
    return v2 if distribution.has_fixed_bounce?
    v3
  end

  def yes_no_read(boolean_value)
    v1 = "yes"
    v2 = "<span style='padding-left: 3px; padding-right: 3px; background-color: lightyellow;'>no</span>"
    boolean_value == true ? v1 : v2
  end



end
