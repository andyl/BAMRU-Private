def gen_array
  @members.in_groups_of(5).reduce([]) do |a,g|
    a << g.map {|m| m.try(:full_name)}
  end
end

prawn_document() do |pdf|

  pdf.text "<b>BAMRU Roster</b>", :align => :center, :inline_format => true
  pdf.text "(current as of #{Time.now.strftime("%D %H:%M")})", :align=>:center

  pdf.move_down 15

  pdf.table(gen_array)

  pdf.move_down 15

  pdf.text "BAMRU Confidential", :size=>8, :align => :center

end