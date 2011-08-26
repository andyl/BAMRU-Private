def typ_label(typ)
  case typ
    when "medical"    : "Medical"
    when "cpr"        : "CPR"
    when "ham"        : "Ham"
    when "tracking"   : "Tracking"
    when "avalanche"  : "Avalanche"
    when "rigging"    : "Rigging"
    when "ics"        : "ICS"
    when "overhead"   : "Search Mgmt."
    when "driver"     : "SO Driver"
    when "background" : "SO Background"
    else "Unknown"
  end
end

def d_expiration(cert)
  return "" if cert.nil?
  cert.expiration
end

def d_description(cert)
  return "" if cert.nil?
  cert.description
end

def d_docco(cert)
  return "" if cert.nil?
  return "see image below"           unless cert.cert_file.blank?
  return "visit: #{cert.link}"       unless cert.link.blank?
  return "comment: #{cert.comment}"  unless cert.comment.blank?
  ""
end

def typ_list
  %w(medical cpr ham tracking avalanche rigging ics overhead driver background)
end

def gen_row(member, typ)
  certs = member.certs.where(:typ => typ)
  certs.map do |cert|
    [typ_label(typ), d_expiration(cert), d_description(cert), d_docco(cert)]
  end
end

def gen_table(member)
  headers = %w(Category Expiration\ Date Description Documentation)
  [headers] + typ_list.map {|typ| gen_row(member, typ)}.flatten(1)
end

prawn_document do |pdf|

  table_opts = {:header        => true,
                :row_colors    => ["ffffff", "eeeeee"]}

  pdf.font_size 12

  pdf.text "<b>BAMRU Member Certifications - Full Export</b>", :inline_format => true
  pdf.text "(current as of #{Time.now.strftime("%D  %H:%M")})"

  @members.each do |m|
    pdf.move_down 15
    pdf.start_new_page if pdf.cursor < 250
    pdf.text "#{m.full_name}"
    pdf.outline.define { page :title => m.full_name, :destination => page_number }
    pdf.font_size 6
    pdf.table(gen_table(m), table_opts)  do
      row(0).style(:font_style => :bold, :background_color => 'cccccc')
    end

    pdf.font_size 8

    m.certs.each do |c|
      unless c.cert_file.blank?
        pdf.move_down 15
        pdf.start_new_page if pdf.cursor < 300
        pdf.text "#{typ_label(c.typ)} Certificate for #{m.full_name} (full-size image at http://bamru.net#{c.cert.url})"
        pdf.image c.cert.path(:full), :fit => [600,300]
      end
    end

    pdf.font_size 12
  end

  pdf.repeat(:all, :dynamic => true) do
    string = "BAMRU Member Certifications / Full Export / BAMRU Confidential / Page #{pdf.page_number}"
    pdf.draw_text string, :at => [0,0]
  end

end