module WikiHelper

  def wiki_nav
    return "" if request.url == new_wiki_path
    return link_to new_wiki_path, "New" if request.url == edit_wiki_path
    new = link_to_unless_current new_wiki_path, "New"
    #edit = link_to_unless_current "/wiki/1/edit", "Edit"
    delete = link_to delete_wiki_path, "Delete"
    "#{new} | #{"edit"} | #{delete}"
  end

end

