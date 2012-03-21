module MessagesHelper
  def dist_label(mesg)
    member_count    = mesg.distributions.count
    outbound_count  = mesg.outbound_mails.count
    "#{pluralize(member_count, "member")} / #{pluralize(outbound_count, "address")}"
  end

  def validate_params(mesg, dist)
    err = ""
    err = "Empty message text"  if mesg.blank? || mesg[:text].blank?
    err = "No address selected" if dist.blank?
    err.blank? ? nil : "#{err} - Please try again"
  end

  def timestamp
    Time.now.strftime("%y%m%d_%H%M%S")
  end

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
    num_yes     = message.distributions.rsvp_yes.count
    num_no      = message.distributions.rsvp_no.count
    num_pending = message.distributions.rsvp_pending.count
    "Yes #{num_yes}, No #{num_no}, PENDING #{num_pending}"
  end

  def sent_display(count, message)
    color = case
      when message.has_open_bounce?  then "yellow"
      when message.has_fixed_bounce? then "#ccffff"
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

  def yes_no_read(boolean_value)
    v1 = "yes"
    v2 = "<span style='padding-left: 3px; padding-right: 3px; background-color: lightyellow;'>no</span>"
    boolean_value == true ? v1 : v2
  end

  def yes_no_bounce(distribution)
    v1 = "<span style='padding-left: 3px; padding-right: 3px; background-color: lightpink;'>yes</span>"
    v2 = "<span style='padding-left: 3px; padding-right: 3px; background-color: #ccffff;'>no</span>"
    v3 = "no"
    return v1 if distribution.has_open_bounce?
    return v2 if distribution.has_fixed_bounce?
    v3
  end

  def message_bounce_helper(distribution)
    v1 = "<span style='margin-left: 5px; padding-left: 3px; padding-right: 3px; background-color: yellow;'>[bounced]</span>"
    v2 = "<span style='margin-left: 5px; padding-left: 3px; padding-right: 3px; background-color: #ccffff;'>(fixed bounce)</span>"
    v3 = ""
    return v1 if distribution.has_open_bounce?
    return v2 if distribution.has_fixed_bounce?
    v3
  end

  def return_date_label(member)
    day = Time.now
    return_date = member.avail_ops.return_date(day)
    return_date.nil? ? "" : (return_date + 1.day).strftime("%b %d")
  end

  def message_oot_helper(distribution)
    return "" unless distribution.created_at.strftime("%y%m%d") == Time.now.strftime("%y%m%d")
    member = distribution.member
    return "" unless member.avail_ops.busy_on?(Time.now)
    " <span style='background: lightpink;'>(<a href='/members/#{member.id}/avail_ops'>unavailable until #{return_date_label(member)}</a>)</span>"
  end




end
