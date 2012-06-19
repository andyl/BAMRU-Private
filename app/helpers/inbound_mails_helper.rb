module InboundMailsHelper

  def delete_link(m)
    if m.outbound_mail_id.nil?
      link_to("Delete", m, :method => :delete, :confirm => "Are you sure?")
    end
  end

  def distribution_link(m)
    unless m.outbound_mail.nil?
      link_to(m.outbound_mail.distribution_id, history_path(m.outbound_mail.distribution))
    end
  end

  def message_link(m)
    unless m.outbound_mail.nil?
      link_to(m.outbound_mail.distribution.message_id, message_path(m.outbound_mail.distribution.message))
    end
  end

  def rsvp_answer(m)
    return m.rsvp_answer unless m.rsvp_answer.nil?
    return "-" if m.outbound_mail.nil?
    return "na" if m.outbound_mail.distribution.rsvp.nil?
    "<b>ERR</b>"
  end

end
