# TODO:
# - add page numbers
# - add headers/footers
# - add county numbers
# - indicate if the email addresses are pagable


pdf.start_new_page(:layout=>:landscape, :top_margin => 30)

pdf.text "BAMRU Field Roster", :size=>9

fields     = %w(role_name mobile_phone home_phone work_phone home_address personal_email home_email work_email ham v9)
hdr_fields = %w(Name Mobile Home Work Home\ Address Personal Home Work Ham V9)

data = gen_array(fields, m_active_array)

pdf.table data, :headers => hdr_fields, 
                :font_size=>6, 
                :padding=>2,
                :row_colors => ["ffffff", "eeeeee"]

pdf.move_down 2
pdf.text "updated #{@update} - BAMRU Confidential", :size=>6

