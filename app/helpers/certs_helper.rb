module CertsHelper
  def display_table_cert(mem, type)
    cert = mem.certs.where(:typ => type).first
    return "<td></td>" if cert.blank?
    cert.display_table
  end

  def td(val)
    "<td>#{val}</td>"
  end

  def expiration(cert)
    cert.nil? ? "" : cert.expiration
  end

  def description(cert)
    cert.nil? ? "" : cert.description
  end

  def comment(cert)
    cert.nil? ? "" : cert.comment
  end

  def documentation(cert)
    return "" if cert.nil?
    return link_to("Doc Image", cert.cert.url) unless cert.cert_file.blank?
    return link_to("FCC", cert.link)           unless cert.link.blank?
    ""
  end

  def cert_actions(mem, cert, type)
    return link_to("CREATE", new_member_cert_path(mem, :typ => type.to_s)) if cert.nil?
    edit = link_to("EDIT", edit_member_cert_path(mem, cert))
    del  = link_to("DELETE", member_cert_path(mem, cert), :confirm => "Are you sure?", :method => :delete)
    "#{edit} | #{del}"
  end

  def can_update?(mem)
    mem == current_member || current_member.admin?
  end

  def cert_value(mem, type)
    action = ()
    cert = mem.certs.where(:typ => type).first
    exp = td(expiration(cert))
    des = td(description(cert))
    com = td(comment(cert))
    doc = td(documentation(cert))
    act = can_update?(mem) ? td(cert_actions(mem, cert, type)) : ""
    exp + des + doc + act
  end

  def color_name(mem)
    link_to(raw(mem.cert_color_name),
            member_certs_path(mem.id),
            :class => "namecolor", :style => "text-decoration:none;"
    )
  end
end
