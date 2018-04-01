def gen_array
  @memreg.in_groups_of(3).reduce([]) do |a,g|
    a << g.map {|m| "#{m.try(:full_name)}\n#{m.try(:address, 'Home').try(:label_address)}"}
  end
end

# top, right, bottom, left
opts = {
  :margin => [30, 0, 0 , 10]
}

prawn_document(opts) do |pdf|

  cell_style = {:width => 195, :height => 72, :padding => 18, :size => 10, :borders => []}

  pdf.table(gen_array, :cell_style => cell_style)

  base_string   = "BAMRU ROSTER - #{Time.now.strftime('%y/%m/%d %H:%M')}"
  avery_string  = "Labels / Avery 5160 - BAMRU Confidential"
  header_string = "#{base_string} - #{avery_string} - Page <page> of <total>"

  header_options = {
            :at => [0, 775],
            :width => 540,
            :align => :center,
            :size => 8
            }

  pdf.number_pages header_string, header_options

end
