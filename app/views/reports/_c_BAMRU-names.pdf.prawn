def gen_array
  @members.in_groups_of(5).reduce([]) do |a,g|
    a << g.map {|m| m.try(:full_name)}
  end
end

prawn_document() do |pdf|

  pdf.text "<b>BAMRU Roster</b>", :inline_format => true

  pdf.move_down 15
  pdf.text "BAMRU is a resource of the San Mateo County Sheriff's Office of Emergency Services."
  pdf.text "Learn more at http://hsd.smcsheriff.com/divisions/homeland-security-division/emergency-services-bureau/search-rescue"

  pdf.move_down 15
  pdf.text "Find BAMRU online at http://bamru.org"

  pdf.move_down 15
  pdf.text "This roster is current as of #{Time.now.strftime("%D %H:%M")}."
  pdf.table(gen_array)

  pdf.move_down 15

  pdf.text "BAMRU Confidential", :size=>8, :align => :center

end
