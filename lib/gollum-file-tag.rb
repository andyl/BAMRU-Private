##
# Monkey-patch custom syntax
# into the gollum wiki engine.
# looks for pattern '{{#file:<file>.<ext>|<label>}} and
# replace it with "<a href='/files/#{file}' target='_blank'>#{label}</a>"
##

class Gollum::Markup

  file_tag_render = instance_method(:render)
  define_method(:render) do |no_follow, encoding|
    reg = /{{ *#file: *([^ ]+) *\| *([\,\-\(\)\w ]+) *}}/
    @data = @data.dup.gsub(reg) do
      file = $1
      ext  = file.split('.')[-1]
      lbl  = $2
      "<a href='/files/#{file}' class=\"target\">#{lbl}</a> [#{ext}]"
    end
    file_tag_render.bind(self).call(no_follow, encoding).gsub('class="target"', "target='_blank'")
  end

end
