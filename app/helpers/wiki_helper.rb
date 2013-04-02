module WikiHelper

  def wiki_nav
    return "" if request.url == '/wiki/new'
    return link_to("New", new_wiki_path) if request.url.include? '/edit'
    new  = link_to_unless_current("New", new_wiki_path)
    edit = link_to_unless_current("Edit", "/wiki/1/edit")
    delete = link_to("Delete", '/wiki/1/delete')
    "#{new} | #{edit} | #{delete}"
  end

end

