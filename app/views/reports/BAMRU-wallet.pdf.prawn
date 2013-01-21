@members = Member.active.order_by_role_score

def str_truncate(string, length)
  new_str = string[0..length]
  new_str[-3..-1] = "..." if new_str != string
  new_str
end


def mem_label(member)
  ol_label = member.ol ? "OL " : ""
  str_truncate "#{ol_label}#{member.typ} #{member.full_name}", 26
end

def phone_for(member)
  member.phones.mobile.first.try(:number) || member.phones.work.first.try(:number)
end

def email_for(member)
  adr = member.emails.personal.first.try(:address) ||
  member.emails.work.first.try(:address)     ||
  member.emails.home.first.try(:address)     ||
  member.emails.other.first.try(:address)
  str_truncate adr, 28
end

def gen_array

  @members.map do |m|
    [
      mem_label(m),
      phone_for(m),
      email_for(m),
    ]
  end

end


prawn_document(:border_width => 0, :page_layout => :landscape, :left_margin => 22, :top_margin => 18, :bottom_margin => 18) do |pdf|

  data = gen_array

  table_opts = {
    :width      => 215,
    :header     => false,
    :row_colors => ["ffffff", "eeeeee"],
    :cell_style => {:overflow => :truncate}
  }

  pdf.move_down 2

  pdf.font_size 6

  pdf.table data, table_opts do

    cells.padding_top    = 1
    cells.padding_bottom = 1
    cells.padding_left   = 3
    cells.padding_right  = 3
    cells.borders = [:left, :right]
    row(0).style(:borders =>  [:top, :left, :right])
    row(-1).style(:borders => [:bottom, :left, :right])
  end

  pdf.move_down 2

  #pdf.text "Updated #{Time.now.strftime("%Y-%m-%d %H:%M")} / BAMRU Confidential"

  pdf.font_size 12

  pdf.draw_text "BAMRU Wallet Roster",              :at=>[475, 550]
  pdf.draw_text "        Make a credit-card size",  :at=>[475, 530]
  pdf.draw_text "        roster for your wallet",   :at=>[475, 515]
  pdf.draw_text "Instructions",                :size=>10, :at=>[475,490]
  pdf.draw_text "1) cut on the dashed line",   :size=>10, :at=>[475,475]
  pdf.draw_text "2) fold in half",             :size=>10, :at=>[475,460]
  pdf.draw_text "3) fold again",               :size=>10, :at=>[475,445]

  even_dash = "---   "
  long_dash = "--------------------                    "
  intr_dash = "---              "
  cutt_dash = "---------     --     "

  black = "000000"
  red   = "ff0000"
  blue  = "0000ff"
  green = "00bb00"

  pdf.canvas do
    pdf.draw_text "BAMRU Roster",                                          :at=>[20, 510], :rotate => 90, :size => 8
    pdf.draw_text "Status Line: 650-858-4618",                             :at=>[20, 330], :rotate => 90, :size => 8
    pdf.draw_text "BAMRU Confidential - #{Time.now.strftime("%Y-%m-%d")}", :at=>[20, 175], :rotate => 90, :size => 6
    pdf.line_width=0.25
    pdf.stroke_color = black
    pdf.stroke do
      pdf.dash(4, :space => 8, :phase => 2)
      pdf.vertical_line(15, 595,:at => 240)
    end
  end

end
