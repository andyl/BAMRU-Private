def bounce_mails
  OutboundMail.bounced.emails.all
end

def bounce_phones
  OutboundMail.bounced.phones.all
end

def mail_hash
  bounce_mails.reduce({}) do |a,v|
    if a[v.id]
      a[v.id][:count] += 1
    else
      if v.email && v.email.address == v.address
        a[v.id] = {
                :count => 1,
                :type  => "eMail",
                :addr => v.address,
                :name => v.email.member.full_name
        }
      end
    end
    a
  end
end

def phone_hash
  bounce_phones.reduce({}) do |a,v|
    if a[v.id]
      a[v.id][:count] += 1
    else
      if v.phone && v.phone.sms_email == v.address
        a[v.id] = {
                :count => 1,
                :type  => "Phone",
                :addr => v.address,
                :name => v.phone.member.full_name
        }
      end
    end
    a
  end
end

def z_headers
  %w(#\ Bounces Address Type Member)
end

def gen_array
  array = (phone_hash.values + mail_hash.values).sort do |a,b|
    b[:count] <=> a[:count]
  end
  [z_headers] + array.map { |h| [h[:count], h[:addr], h[:type], h[:name]] }
end


prawn_document() do |pdf|

  display_table = gen_array

  pdf.text "<b>BAMRU Paging - Bounced Email Addresses</b>", :inline_format => true
  pdf.text "(current as of #{Time.now.strftime("%y-%m-%d %H:%M")})"

  pdf.move_down 15

  pdf.font_size 10

  table_opts = {:header        => true,
                :row_colors    => ["ffffff", "eeeeee"]}

  pdf.table(display_table, table_opts) do
    row(0).style(:font_style => :bold, :background_color => 'cccccc')
  end


  if display_table.length == 1
    pdf.move_down 5
    pdf.text "< NO BOUNCED ADDRESSES>"
  end

  pdf.move_down 15

  pdf.text "BAMRU Confidential", :size=>8

end