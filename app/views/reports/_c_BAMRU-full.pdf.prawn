# TODO: add page header/footer, with page numbers ("page <number> of <total>")
# TODO: format phones, addresses, emails, emergency contacts

def gen_phone_numbers(member)
  member.phones.map do |phone|
    pagable = phone.pagable? ? '[pagable]' : ""
    "#{phone.typ} #{phone.number} #{pagable}"
  end.join("\n")
end

def gen_addresses(member)
  member.addresses.map do |address|
    adr = address.full_address
    "#{address.typ}\n#{adr}"
  end.join("\n\n")
end

def gen_contacts(member)
  member.emergency_contacts.map do |contact|
    "#{contact.name} - #{contact.typ} #{contact.number}"
  end.join("\n")
end

def gen_emails(member)
  member.emails.map do |email|
    "#{email.typ} #{email.address}"
  end.join("\n")
end

def gen_array

  headers = %w(Name\ /\ Role Addresses Phone\ Numbers eMail\ Addresses Emergency\ Contacts)

  data = @members.map do |m|
    ["#{m.full_name}\n#{m.full_roles}",
      gen_addresses(m),
      gen_phone_numbers(m),
      gen_emails(m),
      gen_contacts(m)]
  end
  [headers] + data
end

prawn_document(:page_layout => :landscape) do |pdf|

  pdf.text "BAMRU Full Roster", :size=>9, :align => :center
  pdf.move_down 5
  pdf.text "Updated #{Time.now.strftime("%D %H:%M")} - BAMRU Confidential", :size => 8, :align => :center

  pdf.move_down 15

  pdf.font_size 8

  table_opts = {:header        => true,
                :column_widths => {0=>90, 1=>130, 2=>130, 3=>170 },
                :row_colors    => ["ffffff", "eeeeee"]}

  pdf.table(gen_array, table_opts)  do
    row(0).style(:font_style => :bold, :background_color => 'cccccc')
  end

  footer_string = "BAMRU Confidential - Page <page> of <total>"

  options = {
          :at => [0, 0],
          :width => 150,
          :align => :right
          }

  pdf.number_pages footer_string, options

end