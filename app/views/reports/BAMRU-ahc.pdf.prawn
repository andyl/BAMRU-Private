pdf.start_new_page(:layout=>:landscape, :top_margin => 15, :bottom_margin => 15)

# make a header image
# lay down a big table
# then lay down the final footer...

pdf.header pdf.margin_box.top_left do
    img = "#{BaseDir}/views/bamru-header.jpg"
    pdf.move_down 3
    pdf.image img, :fit=>[700,71], :position => :center 
    pdf.move_down 3
    pdf.stroke_horizontal_rule
    
    pdf.stroke_line(pdf.margin_box.top_left, pdf.margin_box.top_right)
    pdf.stroke_line(pdf.margin_box.bottom_left, pdf.margin_box.top_left)
    pdf.stroke_line(pdf.margin_box.top_right, pdf.margin_box.bottom_right)
    pdf.stroke_line(pdf.margin_box.bottom_left, pdf.margin_box.bottom_right)
end 


pdf.bounding_box([pdf.margin_box.left+10, pdf.margin_box.top - 60],
               :width => pdf.margin_box.width-20,
               :height => pdf.margin_box.height - 75)  do
                 
  fields     = %w(role_name home_phone mobile_phone ham v9)
  hdr_fields = %w(<b>Name</b> Responding Allerton-DR Time\ In ETA Time\ Out Status\ Line <b>Home</b> <b>Mobile</b> <b>Ham</b> <b>V9</b>)
  data       = gen_array(fields, m_array_sorted).map {|x| [x[0], "Y / N / L", " ", " ", " ", " ", " ", x[1], x[2], x[3], x[4]]}
    
  w = 65
  pdf.table data, :font_size=>6, 
                  :headers => hdr_fields, 
                  :horizontal_padding=>4,
                  :vertical_padding => 3,
                  :row_colors => ["ffffff", "eeeeee"],
                  :border_width => 0.25,
                  :align_headers => {2 => :center, 3=>:center, 4=>:center, 5=>:center, 6=>:center},
                  :column_widths => {1=>125, 2=>w, 3=>w, 4=>w, 5=>w, 6=>w}, 
                  :position => :center
                  
  pdf.move_down 10  
  pdf.stroke_horizontal_rule
  pdf.move_down 5
  
  bam_raw = load_table("bamru_phones")
  sh1_raw = load_table("sheriff1")
  sh2_raw = load_table("sheriff2")
  
  bam_data = bam_raw.map {|x| [x.name,x.number]}
  sh1_data = sh1_raw.map {|x| [x.name,x.work,x.pager,x.mobile]}
  sh2_data = sh2_raw.map {|x| [x.name,x.number]}
  
  table_opts = {:font_size=>6, :padding=>2, :row_colors => ["ffffff", "eeeeee"], :border_style => :underline_header}

  tab1 = Prawn::Table.new(sh1_data, pdf, table_opts.merge(:position=>:center))
  tab2 = Prawn::Table.new(sh2_data, pdf, table_opts.merge(:position=>:left  ))
  tab3 = Prawn::Table.new(bam_data, pdf, table_opts.merge(:position=>:right ))

  pdf.start_new_page if tab1.breaks_page? || tab2.breaks_page? || tab3.breaks_page?
  
  start_pos = pdf.cursor  

  tab1.draw  
  pdf.move_up(start_pos - pdf.cursor)
  tab2.draw
  pdf.move_up(start_pos - pdf.cursor)
  tab3.draw

end



