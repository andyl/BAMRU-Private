pdf.start_new_page(:layout=>:landscape, :top_margin => 10, :left_margin => 20, :bottom_margin => 10)

fields     = %w(role_name home_phone mobile_phone ham v9)
hdr_fields = %w(Name Home Mobile Ham V9)

data = gen_array(fields, m_active_array)

pdf.table data, :headers => hdr_fields, 
                :font_size=>6, 
                :padding=>2,
                :row_colors => ["ffffff", "eeeeee"]

pdf.move_down 2
pdf.text "updated #{@update}", :size=>6

pdf.text "BAMRU Wallet Roster",              :at=>[475, 550]
pdf.text "        Make a credit-card size",  :at=>[475, 530]
pdf.text "        roster for your wallet",   :at=>[475, 515]

pdf.text "Instructions", :style=>:bold, :size=>10, :at=>[475,490]
pdf.text "1) cut on the dashed line",   :size=>10, :at=>[475,475]
pdf.text "2) fold in half",             :size=>10, :at=>[475,460]
pdf.text "3) fold again",               :size=>10, :at=>[475,445]

even_dash = "---   "
long_dash = "--------------------                    "
intr_dash = "---              "
cutt_dash = "---------     --     "

black = "000000"
red   = "ff0000"
blue  = "0000ff"
green = "00bb00"

pdf.line_width = 0.5

pdf.canvas do
  pdf.text "BAMRU Wallet Roster", :at=>[18, 495], :rotate => 90, :size => 8, :style => :bold
  pdf.text "BAMRU Status: 650-858-4618", :at=>[18, 330], :rotate => 90, :size => 8, :style => :bold 
  pdf.line_width=0.5
  pdf.stroke_color = black
  pdf.vertical_dash_line(240,0,650,long_dash)
end