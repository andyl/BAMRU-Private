module WikiHelper

  def wiki_path
    return "wiki" if @path.length == 1
    return "<a href='/wiki'>wiki</a> / #{@path[1]}" if @path.length == 2
    "<a href='/wiki'>wiki</a> / <a href='/wiki/#{@path[1]}'>#{@path[1]}</a> / #{@path[2]}"
  end

  def wiki_dirs
    return '' if @dirs.blank?
    dir_list = @dirs.map do |dir|
      "<a href='/wiki/#{dir}'>#{dir}</a><br/>"
    end.join
    "<b>Directories</b><br/>#{dir_list}<p></p>"
  end

  def wiki_pages
    return '' if @pages.blank?
    page_list = @pages.map do |page|
      "<a href='/wiki/#{page.url_path}/show'>#{page.url_path}</a><br/>"
    end.join
    "<b>Pages</b><br/>#{page_list}<p></p>"
  end

  def wiki_nav
    #return "" if request.url == '/wiki/new'
    #return link_to("New", new_wiki_path) if request.url.include? '/edit'
    #new  = link_to_unless_current("New", new_wiki_path)
    #edit = link_to_unless_current("Edit", "/wiki/1/edit")
    #delete = link_to("Delete", '/wiki/1/delete')
    #"#{new} | #{edit} | #{delete}"
    "New | Edit | Rename | Delete TBD"
  end

end

