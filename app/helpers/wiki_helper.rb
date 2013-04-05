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

  def wiki_index_nav
    "New"
  end

  def wiki_show_nav
    edit   = "<a href='/wiki/#{@page.try(:url_path)}/edit'>Edit</a>"
    rename = "<a href='/wiki/#{@page.try(:url_path)}/rename'>Rename</a>"
    "New | #{edit} | #{rename} | Delete"
  end

  def wiki_edit_nav
    <<-EOF
    <form action="/wiki/#{@page.url_path}" method='post'>
      <input name="_method" type='hidden' value='put'>
      <input name='authenticity_token' type='hidden' value='#{form_authenticity_token}'>
      Comment: <input />
      <input type='submit' value='Save'/> | <a href='/wiki/#{@page.url_path}/show'>Cancel</a>
    EOF
  end

  def wiki_rename_nav
    <<-EOF
    <form action="/wiki/#{@page.url_path}/rename" method='post'>
      <input name="_method" type='hidden' value='put'>
      <input name='authenticity_token' type='hidden' value='#{form_authenticity_token}'>
      <input type='submit' value='Save'/> | <a href='/wiki/#{@page.url_path}/show'>Cancel</a>
    EOF
  end

  def wiki_rename_content
    <<-EOF
      Current page name: #{@page.url_path}<p></p>
      New page name: <input name='newpage' value='#{@page.url_path}'/>
      </form>
    EOF
  end

end

