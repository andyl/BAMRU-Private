module CertsHelper
  def cert_image_label(cert)
    cert.cert_file_name.blank? ? "Cert File" : "New Cert File"
  end

  def current_cert_helper(cert)
    return "" if cert.cert_file_name.blank?
    <<-EOF
    <div class='input file optional'>
      <label class='optional'> </label>
      <span class='select optional'>
        <a href='#{cert.cert.url}' target='_blank'>Current Cert File</a>
        (<input type=checkbox id=check_del name=check_del> delete?)
      </span>
    </div>
    EOF
  end

  def display_table_cert(mem, type)
    cert = mem.certs.where(:typ => type).order('position ASC').first
    return "<td></td>" if cert.blank?
    cert.display_table(mem.certs.where(:typ => type).count)
  end
 
  def td(val)
    "<td>#{val}</td>"
  end

  def expiration(cert)
    return "" if (cert.nil? || cert.expiration.nil?)
    date = cert.expiration.strftime("%Y-%m-%d")
    color = cert.expire_color
    "<span style='background-color: #{color}; padding-left: 2px; padding-right: 2px;'>#{date}</span>"
  end

  def description(cert)
    handle = ""
    count = cert.member.certs.where(:typ => cert.typ).count
    prefix = count == 1 ? "gray_" : ""
    if current_member == cert.member || current_member.admin?
      handle = "<span class=#{prefix}sort_handle><img class=#{prefix}handle src='/images/#{prefix}handle.png'></span> "
    end
    cert.nil? ? handle : handle + cert.description
  end

  def comment(cert)
    cert.nil? ? "" : cert.comment
  end

  def documentation(cert)
    return "" if cert.nil?
    return link_to("Cert File", cert.cert.url, :target => "_blank")   unless cert.cert_file_name.blank?
    return "link: #{link_to("FCC", cert.link, :target => "_blank")}"   unless cert.link.blank?
    return cert.comment                                                unless cert.comment.blank?
    ""
  end

  def cert_actions(mem, cert, type)
    return link_to("create", new_member_cert_path(mem, :typ => type.to_s)) if cert.nil?
    edit = link_to("edit", edit_member_cert_path(mem, cert))
    del  = link_to("delete", member_cert_path(mem, cert), :confirm => "Are you sure?", :method => :delete)
    "#{edit} | #{del}"
  end

  def can_update?(mem)
    mem == current_member || current_member.admin?
  end

  def add_link(mem, type)
    can_update?(mem) ? link_to("add", new_member_cert_path(mem, :typ => type.to_s)) : ""
  end

  def col1() 225; end
  def col2() 225; end
  def col3() 100; end

  def do_span(text, width, size=10)
    "<span style='display: inline-block; width: #{width}px; font-size: #{size}px;'>#{text}</span>"
  end

  def cert_count(mem, type)
    mem.certs.where(:typ => type).count
  end

  def cert_labels(label, mem, type)
    count = cert_count(mem, type)
    s1 = label
    s2 = count == 0 ? "" : "| <b>Documentation</b>"
    s3 = count == 0 ? "" : "| <b>Expiration</b>"
    s4 = "<span style='float: right;'>#{add_link(mem, type)}</span>"
    do_span(s1, col1, 12) + do_span(s2, col2) + do_span(s3, col3) + s4
  end

  def cert_header(label, mem, type)
    label_count = "<b>#{label}</b> (#{cert_count(mem, type)})"
    "<div class=cert_header>" +
    cert_labels(label_count, mem, type) +
    "</div>"
  end

  def cert_category(label, mem, type)
    "#{cert_header(label, mem, type)}#{cert_dump(mem, type)}<div class=cert_divider></div>"
  end

  def cert_dump(mem, type)
    certs = mem.certs.where(:typ => type).order('position ASC')
    "<div id=sortable_#{type}_certs>" +
    certs.map do |cert|
      des = description(cert)
      exp = "| " + expiration(cert)
      doc = "| " + documentation(cert)
      act = can_update?(mem) ? td(cert_actions(mem, cert, type)) : ""
      "<li style='list-style-type: none; font-size: 10px;' id=cert_#{cert.id}>" + do_span(des, col1) + do_span(doc, col2) + do_span(exp, col3) + " " + "<span style='float:right'>#{act}</span>" + "</li>"
    end.join + "</div>"
  end

  def cert_value(mem, type)
    cert = mem.certs.where(:typ => type).first
    exp = td(expiration(cert))
    des = td(description(cert))
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

  def cert_opts(cert)
    vals = Cert.select(:description).
                where(:typ => cert.typ).
                where('description != ?', "").
                group(:description).
                order('description ASC')
    vals.map {|item| [item.description, item.description]} + [['< add new >', '*']]
  end
end
