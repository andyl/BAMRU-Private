# TODO: add page header/footer, with page numbers ("page <number> of <total>")
# TODO: format phones, addresses, emails, emergency contacts

def gen_array

  headers = %w(Name\ /\ Role Addresses Phone\ Numbers eMail\ Addresses Contacts)

  data = @members.map do |m|
    ["#{m.full_name} / #{m.full_roles}",
      m.addresses.first.try(:full_address),
      m.phones.first.try(:number),
      m.emails.first.try(:address),
      m.emergency_contacts.first.try(:name)]
  end
  [headers] + data
end

prawn_document() do |pdf|

  pdf.text "BAMRU Full Roster\n(report status: in development)", :size=>9, :align => :center

  pdf.move_down 15
  
  pdf.font_size 8

  table_opts = {:header        => true,
                :column_widths => {4=>80},
                :row_colors    => ["ffffff", "eeeeee"]}

  pdf.table(gen_array, table_opts)  do
    row(0).style(:font_style => :bold, :background_color => 'cccccc')
  end

  pdf.move_down 15
  pdf.text "updated #{Time.now.strftime("%D %H:%M")} - BAMRU Confidential", :size=>6, :align => :center
end