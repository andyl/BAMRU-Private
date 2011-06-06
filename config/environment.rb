# Load the rails application
require File.expand_path('../application', __FILE__)

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  debugger
  error_style = "background-color: #ffff80"
  if html_tag =~ /<(input|textarea|select)[^>]+style=/
    style_attribute = html_tag =~ /style=['"]/
    html_tag.insert(style_attribute + 7, "#{error_style}; ")
  elsif html_tag =~ /<(input|textarea|select)/
    first_whitespace = html_tag =~ /\s/
    html_tag[first_whitespace] = " style='#{error_style}' "
  end
  html_tag
end

# Initialize the rails application
Zn::Application.initialize!

