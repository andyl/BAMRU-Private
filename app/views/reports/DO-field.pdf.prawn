# TODO:
# - add page numbers
# - add headers/footers
# - add county numbers
# - indicate if the email addresses are pagable

@period = Period.find(@period_id)
@participants = @period.participants.sort{|x,y| x.sort_key <=> y.sort_key}

def role_label(participant)
  ol_label = participant.ol ? "OL " : ""
  "#{ol_label}#{participant.member.typ}"
end

def phone_for(participant)
  phones = participant.member.phones
  phones.mobile.first.try(:number) || phones.work.first.try(:number) || phones.home.first.try(:number)
end

def email_for(participant)
  member = participant.member
  member.emails.personal.first.try(:address) ||
  member.emails.work.first.try(:address)     ||
  member.emails.home.first.try(:address)     ||
  member.emails.other.first.try(:address)
end

def gen_array

  hdr_fields = %w(# Role Name Phone eMail Left\ Home\ At Returned\ Home\ At)

  idx = 0

  data = @participants.map do |participant|
    [
      idx += 1,
      role_label(participant),
      participant.member.full_name,
      phone_for(participant),
      email_for(participant),
      participant.en_route_at.strftime("%b-%d %H:%M"),
      participant.return_home_at.strftime("%b-%d %H:%M")
    ]
  end

  [hdr_fields] + data

end


prawn_document(:border_width => 0, :page_layout => :portrait, :top_margin => 30, :bottom_margin => 30) do |pdf|

  pdf.text "DO Transit Roster / #{@period.event.title} / Period #{@period.position} / Updated #{Time.now.strftime("%Y-%m-%d %H:%M")} / BAMRU Confidential", :size=>9

  data = gen_array

  table_opts = {
    :header     => true,
    :row_colors => ["ffffff", "eeeeee"]
  }

  pdf.move_down 2

  pdf.font_size 7

  pdf.table data, table_opts do
    cells.padding_top    = 1
    cells.padding_bottom = 1
    cells.padding_left   = 5
    cells.padding_right  = 5
    cells.borders = [:left, :right]
    row(0).style(:borders => [:top, :left, :right], :font_style => :bold, :background_color => 'cccccc', )
    row(-1).style(:borders => [:bottom, :left, :right])
  end

end
