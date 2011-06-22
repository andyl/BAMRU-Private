pdf.start_new_page(:layout=>:landscape, :top_margin => 10, :left_margin => 20, :right_margin => 20, :bottom_margin => 10)

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
# render the roster table
#
fields     = %w(role_name home_phone mobile_phone ham v9)
hdr_fields = %w(Name Home Mobile Ham V9)
data       = gen_array(fields, m_active_array)

pdf.table data, :headers => hdr_fields, 
                :font_size=>6, 
                :padding=>2,
                :row_colors => ["ffffff", "eeeeee"]

pdf.move_down 2
pdf.text "updated #{@update} - <b>BAMRU Confidential</b>", :size=>6

pdf.canvas do
  pdf.text "BAMRU Wallet Roster", :at=>[18, 495], :rotate => 90, :size => 8, :style => :bold
  pdf.text "BAMRU Status: 650-858-4618", :at=>[18, 330], :rotate => 90, :size => 8, :style => :bold 
end

# ------------------------------------------------------------------------------------------------
# AHC Instruction
#

hdr_fields = %w(Name/Org Mobile Work)

bam_raw = load_table("bamru_phones")
s1 = load_table("sheriff1")
s2 = load_table("sheriff2")

bam_data = bam_raw.map {|x| [x.name,x.number]}

pdf.canvas do
  pdf.bounding_box([250,602], :width => 220, :height => 587) do
    pdf.table bam_data, :font_size=>6, 
                        :padding=>2,
                        :row_colors => ["ffffff", "eeeeee"],
                        :position => :center
    pdf.move_down 4
    pdf.text File.read("#{BaseDir}/data/AHC-guide.htm"), :size=>6
  end  
end


# --------------------------------------------------------------------------------------------------
# Sidebar
#
sidebar(pdf, "BAMRU Wallet Roster", pse)

# --------------------------------------------------------------------------------------------------
# start new page
#
pdf.start_new_page

pdf.canvas do

  pdf.bounding_box([322,602], :width => 470, :height => 587) do
    img = "#{BaseDir}/views/survey1.jpg"
    pdf.image img, :fit=>[470,587]        
  end

end

