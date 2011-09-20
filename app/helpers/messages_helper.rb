module MessagesHelper
  def span_wrap(value, color = "white")
    padding = "3px"
    "<span style='background-color: #{color}; padding-left: #{padding}; padding-right: #{padding};'>#{value}</span>"
  end

  def sent_display(count, bounce_count)
    color = bounce_count == 0 ? "white" : "lightpink"
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

  def yes_no_bounce(boolean_value)
    v1 = "<span style='padding-left: 3px; padding-right: 3px; background-color: lightpink;'>yes</span>"
    v2 = "no"
    boolean_value == true ? v1 : v2
  end

  def yes_no_read(boolean_value)
    v1 = "yes"
    v2 = "<span style='padding-left: 3px; padding-right: 3px; background-color: lightyellow;'>no</span>"
    boolean_value == true ? v1 : v2
  end



end
