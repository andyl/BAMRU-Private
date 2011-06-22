pdf.start_new_page(:layout=>:portrait, :top_margin => 30)

pdf.text "BAMRU Full Roster", :size=>9

t_nam = "<%= full_name %>\n<%= roles %>"
t_adr = <<-EOF
<% addresses.each do |adr| %>
<b><%= adr.typ %></b> - <%= adr.address1 %> <%= adr.address2 %> <%= adr.city %> <%= adr.state %> <%= adr.zip %><br />
<% end %>
EOF
t_pho = <<-EOF
<% hwm_phones.each do |pho| %>
<b><%= pho.typ %></b> <%= pho.number %><br />
<% end %>
EOF
t_ema = <<-EOF
<% emails.each do |ema| %>
<b><%= ema.typ %></b> <%= ema.email %><br />
<% end %>
EOF
t_notes = <<-EOF
<% alt_phones.each do |pho| %>
<b><%= pho.typ %></b> <%= pho.number %><br />
<% end %>
<% unless ham.nil? || ham.empty? %>
<b>Ham License</b> - <%= ham %>
<% end %>
<% unless v9.nil? || v9.empty? %>
<b>V9</b> - <%= v9 %>
<% end %>
EOF

hdr_fields = %w(Name\ /\ Role Addresses Phone\ Numbers eMail\ Addresses Contacts)

data = gen_array_erb([t_nam, t_adr, t_pho, t_ema, t_notes])

pdf.table data, :headers => hdr_fields, 
                :font_size=>6, 
                :padding=>2,
                :column_widths => {1=>70,2=>70}, 
                :row_colors => ["ffffff", "eeeeee"]

pdf.move_down 2
pdf.text "updated #{@update} - BAMRU Confidential", :size=>6

