# TODO: add page header/footer, with page numbers ("page <number> of <total>")
# TODO: format phones, addresses, emails, emergency contacts

def gen_array

#    t_nam = "<%= full_name %>\n<%= roles %>"
#  t_adr = <<-EOF
#<% addresses.each do |adr| %>
#<b><%= adr.typ %></b> - <%= adr.address1 %> <%= adr.address2 %> <%= adr.city %> <%= adr.state %> <%= adr.zip %><br />
#<% end %>
#  EOF
#  t_pho = <<-EOF
#<% hwm_phones.each do |pho| %>
#<b><%= pho.typ %></b> <%= pho.number %><br />
#<% end %>
#  EOF
#  t_ema = <<-EOF
#<% emails.each do |ema| %>
#<b><%= ema.typ %></b> <%= ema.email %><br />
#<% end %>
#  EOF
#  t_notes = <<-EOF
#<% alt_phones.each do |pho| %>
#<b><%= pho.typ %></b> <%= pho.number %><br />
#<% end %>
#<% unless ham.nil? || ham.empty? %>
#<b>Ham License</b> - <%= ham %>
#<% end %>
#<% unless v9.nil? || v9.empty? %>
#<b>V9</b> - <%= v9 %>
#<% end %>
#  EOF

  headers = %w(Name\ /\ Role Addresses Phone\ Numbers eMail\ Addresses Contacts)

  data = @members.reduce([]) do |a,m|
    a << ["#{m.full_name} / #{m.full_roles}",
          m.addresses.first.try(:full_address),
          m.phones.first.try(:number),
          m.emails.first.try(:address),
          m.emergency_contacts.first.try(:name)]
  end
  [headers] + data
end

prawn_document() do |pdf|

  pdf.text "BAMRU Full Roster\n(report status: in development)", :size=>9, :align => :center

  pdf.font_size 8

  table_opts = {:header        => true,
                :column_widths => {4=>80},
                :row_colors    => ["ffffff", "eeeeee"]}

  pdf.table(gen_array, table_opts)  do
    row(0).style(:font_style => :bold, :background_color => 'cccccc')
  end

  pdf.move_down 2
  pdf.text "updated #{Time.now.strftime("%D %H:%M")} - BAMRU Confidential", :size=>6, :align => :center
end