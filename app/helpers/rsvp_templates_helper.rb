module RsvpTemplatesHelper

  def col_widths
    [85, 150, 150, 150, 75]
  end

  def span_wrap_header(text, col)
    width = col_widths[col]
    "<span style='display: inline-block; width: #{width}px; font-size: 10px; font-weight: bold;'>#{text}</span>"
  end

  def span_wrap_row(text, col)
    width = col_widths[col]
    "<span style='display: inline-block; width: #{width}px; font-size: 10px;'>#{text}</span>"
  end

  def dump_table_headers
    table_headers = %w(Name Prompt Yes\ Prompt No\ Prompt Action)
    hdr = table_headers.each_with_index.map {|x| span_wrap_header(x.first, x.last)}.join
    "<span style='display: inline-block; width:15px;'> </span>#{hdr}"
  end

  def row_action(template)
    edit = link_to "EDIT", edit_rsvp_template_path(template)
    delete = link_to "DELETE", rsvp_template_path(template), :method => :delete
    "#{edit} | #{delete}"
  end

  def dump_table_row(template)
    handle = "<span class=sort_handle><img class=sort_handle src='/images/handle.png'></span> "
    row  = span_wrap_row(template.name, 0)        +
           span_wrap_row(template.prompt, 1)      +
           span_wrap_row(template.yes_prompt, 2)  +
           span_wrap_row(template.no_prompt, 3)   +
           span_wrap_row(row_action(template), 4)
    "<li id='template_#{template.id}'>#{handle}#{row}</li>"
  end

  def dump_table_rows
    rows = @templates.map {|x| dump_table_row(x)}
    "<div id='sortable_templates'>#{rows}</div>"
  end
  
  def template_output
    "{dump_table_headers}{cert_dump(mem, type)}<div class=cert_divider></div>"
    "#{dump_table_headers}<br/>#{dump_table_rows}"
  end

end
