def msgs
  Message.order('id DESC').all
end

def response_display(message, seconds)
  total = message.distributions.count
  window  = message.distributions.response_less_than(seconds).count
  percent = ((window * 100) / total).to_i
  "#{percent}% (#{window} of #{total})"
end

def msg_table
  msgs.map do |x|
    [
            x.id,
            x.author.short_name,
            x.text,
            x.created_at.strftime("%y-%m-%d %H:%M:%S"),
            x.distributions.count,
            x.distributions.bounced.count,
            x.distributions.read.count,
            response_display(x, 60 * 15),
            response_display(x, 60 * 60),
            response_display(x, 60 * 120)
    ]
  end
end

def z_headers
  %w(ID From Message\ Text Sent\ at Sent Bounced Read 15m\ Response 60m\ Response 120m\ Response)
end

def gen_array
  [z_headers] + msg_table
end


prawn_document(:page_layout => :landscape) do |pdf|

  pdf.text "<b>BAMRU Paging System / Response Times</b>", :inline_format => true
  pdf.text "(current as of #{Time.now.strftime("%y-%m-%d %H:%M")})"

  pdf.move_down 15

  pdf.font_size 8

  table_opts = {:header        => true,
                :column_widths => {2=>250},
                :row_colors    => ["ffffff", "eeeeee"]}

  pdf.table(gen_array, table_opts) do
    row(0).style(:font_style => :bold, :background_color => 'cccccc')
  end

  pdf.move_down 15

  pdf.text "BAMRU Confidential", :size=>8

end