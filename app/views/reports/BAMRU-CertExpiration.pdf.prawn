certs = Cert.pending_and_expired

data  = certs.map do |c|
  [c.member.full_name, c.typ, c.description, c.expiration, c.status]
end

hdr_fields = %w(Member\ Name Cert\ Type Cert\ Description Expiration\ Date Status)
prawn_table = [hdr_fields] + data

prawn_document do |pdf|

  pdf.text "<b>BAMRU Member Certifications - Expired and Pending</b>", :inline_format => true
  pdf.text "(current as of #{Time.now.strftime("%D %H:%M")})"

  pdf.move_down 15

  table_opts = {:header => true,
                :row_colors => ["ffffff", "eeeeee"]}

  pdf.table(prawn_table, table_opts) do
    row(0).style(:font_style => :bold, :background_color => "cccccc")
  end

  pdf.move_down 5

  pdf.text "(Pending certifications will expire in the next 90 days.)", :size=>8

  pdf.move_down 15
  pdf.text "BAMRU Confidential"

end
