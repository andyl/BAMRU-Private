pdf.start_new_page(:layout=>:landscape, :top_margin => 10, :left_margin => 20, :right_margin => 20)

# --------------------------------------------------------------------------------------------------
# script variables
#
pse = {}
pse[:even_dash] = "---   "
pse[:long_dash] = "--------------------                    "
pse[:intr_dash] = "---              "
pse[:cutt_dash] = "---------     --     "

pse[:black] = "000000"
pse[:red]   = "ff0000"
pse[:blue]  = "0000ff"
pse[:green] = "00bb00"

pdf.line_width = 0.5

# --------------------------------------------------------------------------------------------------
# Patient Report Side 1
#
pdf.canvas do
 pdf.bounding_box([20,602], :width => 450, :height => 587) do
    img = "#{BaseDir}/views/survey1.jpg"
    pdf.image img, :fit=>[450,587]
  end
end

pdf.canvas do
  pdf.text "Foster Calm Patient Report", :at=>[18, 490], :rotate => 90, :size => 8, :style => :bold
  pdf.text "Produced by BAMRU",          :at=>[18, 350], :rotate => 90, :size => 8, :style => :bold
  pdf.text "http://bamru.info/fcpr",     :at=>[18, 195], :rotate => 90, :size => 8, :style => :bold
end

# --------------------------------------------------------------------------------------------------
# Sidebar
#

sidebar(pdf, "Foster Calm Patient Report", pse)

# --------------------------------------------------------------------------------------------------
# start new page
#
pdf.start_new_page


# --------------------------------------------------------------------------------------------------
# Patient Report Side 2
#
pdf.canvas do

  pdf.bounding_box([322,602], :width => 470, :height => 587) do
    img = "#{BaseDir}/views/survey2.jpg"
    pdf.image img, :fit=>[470,587]
  end

end

