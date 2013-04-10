##
# This is an example of how one might go about monkey-patching custom syntax
# into the gollum wiki engine.
##

# Monkey Patch the gollum library to support {.css-class} syntax
# Mechanics derived from http://stackoverflow.com/questions/4470108/when-monkey-patching-a-method-can-you-call-the-overridden-method-from-the-new-i
class Gollum::Markup

  # Add our class variable, cssmap.
  old_initialize = instance_method(:initialize)
  define_method(:initialize) do |page|
    old_initialize.bind(self).call(page)
    @cssmap = {}
  end

  # Subvert the render method, wrap it with our two calls, extract and process
  # Definitely one of those times I miss Moose.
  old_render = instance_method(:render)
  define_method(:render) do |no_follow,encoding|
    orig_data = @data.dup
    @data = extract_css(@data.dup)
    doc = old_render.bind(self).call(no_follow, encoding)
    doc = process_css(doc)
    return doc
  end

  # Replace our tokens with html p tags. They will be left mostly untouched by Gollum's render methods
  def extract_css data
    # This method extracts all the {.css-class} lines and replaces them with a <p></p> marker
    # so the process_css method can fix them. We do this to survive thet markdown formatter.
    # Each marker has two classes, one to uniquely identify it and another to identify them as a group.
    # this latter marker is used during clean-up.
    data.gsub /^[ \t]*\{\.(-?[_a-zA-Z]+[_a-zA-Z0-9-]*)}\r?$/m do
      class_name = $1
      id = "css-" + Digest::SHA1.hexdigest(class_name)
      @cssmap[id] = class_name
      "<p class='__marker #{id}'>save me</p>"
    end
  end

  # Find our p tags and perform the appropriate fixes
  def process_css doc
    # Re-parse the document html and then query using css selectors to find our markers.
    # Replacing the markers with css classes on the next sibling element.
    return doc if doc.nil? || @cssmap.size.zero?

    # This is dumb, render returns the html as a string, so we have to re-parse it
    # to be able to use Nokogiri methods on it.
    doc = Nokogiri::HTML::DocumentFragment.parse(doc)
    doc.css("p").each do |element|
      if element.content() == ""
        element.remove()
      end
    end

    @cssmap.each do |id, class_name|
      doc.css("p.#{id} + *").each do |element|
        element_class = element['class'] || ""
        element_class += " #{class_name}"
        element['class'] = element_class
      end
    end

    doc.css("p.__marker").each do |e| e.remove end

    # Return the xml.
    doc.to_xml(@to_xml)
  end
end

# Now begin Gollum app initialization...