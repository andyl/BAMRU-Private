module WikiHelper

  def wiki_nav_path
    wiklink = "<a href='/wiki'>wiki</a>"
    if @path.first == "new"
      case @path.length
        when 1 then wiklink
        else "#{wiklink} / <a href='/wiki/#{@path[1]}'>#{@path[1]}</a>"
      end
    else
      case @path.length
        when 1 then wiklink
        when 2 then "<a href='/wiki'>wiki</a> / #{@path[1]}"
        else "#{wiklink} / <a href='/wiki/#{@path[1]}'>#{@path[1]}</a> / #{@path[2]}"
      end
    end
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
    path = @dir.nil? ? "" : "#{@dir}/"
    new    = "<a href='/wiki/#{path}new?cancel=/wiki/#{path}'>New</a>"
    new
  end

  def wiki_show_nav
    path = @dir.nil? ? "" : "#{@dir}/"
    new    = "<a href='/wiki/#{path}new?cancel=/wiki/#{@page.try(:url_path)}/show'>New</a>"
    edit   = "<a href='/wiki/#{@page.try(:url_path)}/edit'>Edit</a>"
    rename = "<a href='/wiki/#{@page.try(:url_path)}/rename'>Rename</a>"
    delete = "<a href='/wiki/#{@page.try(:url_path)}/delete'>Delete</a>"
    "#{new} | #{edit} | #{rename} | #{delete}"
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

  def wiki_edit_content
    <<-EOF
    <textarea rows=25 cols=80 name='text_area'>#{@page.raw_data}</textarea>
    </form>
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

  def wiki_new_nav
    <<-EOF
    <form action="/wiki" method='post'>
      <input name='authenticity_token' type='hidden' value='#{form_authenticity_token}'>
      <input type='submit' value='Save'/> | <a href='#{@cancel}'>Cancel</a>
    EOF
  end

  def wiki_new_content
    <<-EOF
      New page name: <input name='newpage' value=''/>
      <textarea rows=25 cols=80 name='text_area'>New content here...</textarea>
      </form>
    EOF
  end

end

