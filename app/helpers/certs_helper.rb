module CertsHelper
  
  def can_update?(mem)
    mem == @context.current_member || @context.current_member.admin?
  end

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
        (<input type=checkbox id=check_del name=check_del> delete)
      </span>
    </div>
    EOF
  end

  def display_table_cert(mem, type)
    cert = mem.certs.where(:typ => type).order('position ASC').first
    return "<td></td>" if cert.blank?
    cert.display_table(mem.certs.where(:typ => type).count)
  end

  def comment(cert)
    cert.nil? ? "" : cert.comment
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

  def std_cert_category(*args)
    "#{StdCert.new(args, self).render}<div class=cert_divider></div>"
  end

  def adm_cert_category(*args)
    "#{AdmCert.new(args, self).render}<div class=cert_divider></div>"
  end

end

class BaseCert

  def initialize(args, context)
    @label, @mem, @type = args
    @context = context
  end

  def render
    cert_header + cert_body
  end

  # ----- Header -----

  def cert_header
    label_count = "<b>#{@label}</b> (#{cert_count})"
    "<div class=cert_header>" +
        cert_labels(label_count) +
        "</div>"
  end

  def cert_labels(label_count)
    count = cert_count
    s1 = label_count
    s2 = count == 0 ? "" : "| <b>Documentation</b>"
    s3 = count == 0 ? "" : "| <b>Expiration</b>"
    s4 = "<span style='float: right;'>#{add_link}</span>"
    do_span(s1, col1, 12) + do_span(s2, col2) + do_span(s3, col3) + s4
  end

  def add_link
    can_update?(@mem) ? @context.link_to("add", @context.new_member_cert_path(@mem, :typ => @type.to_s)) : ""
  end

  def cert_count
    @mem.certs.where(:typ => @type).count
  end

  def do_span(text, width, size=10)
    "<span style='display: inline-block; width: #{width}px; font-size: #{size}px;'>#{text}</span>"
  end

  # ----- Body -----

  def cert_body
    certs = @mem.certs.where(:typ => @type).order('position ASC')
    "<div id=sortable_#{@type}_certs>" +
        certs.map do |cert|
          des = description(cert)
          exp = "| " + expiration(cert)
          doc = "| " + documentation(cert)
          act = can_update?(@mem) ? td(cert_actions(@mem, cert, @type)) : ""
          "<li style='list-style-@type: none; font-size: 10px;' id=cert_#{cert.id}>" + do_span(des, col1) + do_span(doc, col2) + do_span(exp, col3) + " " + "<span style='float:right'>#{act}</span>" + "</li>"
        end.join + "</div>"
  end

  def description(cert)
    handle = ""
    count = cert.member.certs.where(:typ => cert.typ).count
    prefix = count == 1 ? "gray_" : ""
    if @context.current_member == cert.member || @context.current_member.admin?
      handle = "<span class=#{prefix}sort_handle><img class=#{prefix}handle src='/images/#{prefix}handle.png'></span> "
    end
    cert.nil? ? handle : handle + cert.description
  end

  def expiration(cert)
    return "" if (cert.nil? || cert.expiration.nil?)
    date = cert.expiration.strftime("%Y-%m-%d")
    color = cert.expire_color
    "<span style='background-color: #{color}; padding-left: 2px; padding-right: 2px;'>#{date}</span>"
  end

  def documentation(cert)
    return "" if cert.nil?
    return @context.link_to("Cert File", cert.cert.url, :target => "_blank")   unless cert.cert_file_name.blank?
    return "link: #{@context.link_to("FCC", cert.link, :target => "_blank")}"  unless cert.link.blank?
    return cert.comment                                               unless cert.comment.blank?
    ""
  end

  def cert_actions(mem, cert, type)
    return @context.link_to("create", @context.new_member_cert_path(mem, :typ => type.to_s)) if cert.nil?
    edit = @context.link_to("edit", @context.edit_member_cert_path(mem, cert))
    del  = @context.link_to("delete", @context.member_cert_path(mem, cert), :confirm => "Are you sure?", :method => :delete)
    "#{edit} | #{del}"
  end

  # ----- utility -----

  def can_update?(mem)
    mem == @context.current_member || @context.current_member.admin?
  end

  private

  def td(val)
    "<td>#{val}</td>"
  end

  def col1() 225; end
  def col2() 225; end
  def col3() 100; end

end

class StdCert < BaseCert
end

class AdmCert < BaseCert
  def can_update?(mem)
    @context.current_member.admin?
  end
end