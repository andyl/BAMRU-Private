require 'gollum-lib'
require 'gollum-file-tag'

class WikiController < ApplicationController

  before_filter :authenticate_member!

  def index
    setenv
  end
  
  def new
    setenv
    @cancel  = params['cancel']
    @path[0] = "new"
  end

  def show
    setenv
  end

  def create
    setenv
    #noinspection RubyArgCount
    @wiki.write_page(params['newpage'], :markdown, params["text_area"], commit)
    redirect_to "/wiki/#{params['newpage']}/show", :notice => "Successful Creation"
  end

  def edit
    setenv
  end

  def history
    setenv
    @versions = @page.versions
  end

  def rename
    setenv
  end

  def update
    setenv
    #noinspection RubyArgCount
    @wiki.update_page(@page, @page.name, @page.format, params["text_area"], commit)
    redirect_to "/wiki/#{@page.url_path}/show", :notice => "Successful Update"
  end

  def reproc
    setenv
    @wiki.rename_page(@page, params['newpage'], commit)
    redirect_to "/wiki/#{params['newpage']}/show", :notice => "Successful Update"
  end

  def destroy
    setenv
    @wiki.delete_page(@page, commit)
    ext = @dir.nil? ? "" : "/#{@dir}"
    redirect_to "/wiki#{ext}", :notice => "Page was deleted"
  end

  private

  def commit
    {
      message: "HELLO THERE",
      name:    current_member.full_name,
      email:   current_member.emails.first.address
    }
  end

  def setenv
    @wiki  = Gollum::Wiki.new(Rails.root.join('wiki').to_s, :base_path => "../wiki")
    @dir = params['dir']
    page = params['page']
    @path  = get_path(@wiki, @dir, page)
    @dirs  = get_dirs(@wiki, @dir)
    @pages = get_pages(@wiki, @dir)
    #noinspection RubyArgCount
    @page = @pages.select {|x| x.url_path.split('/').last == page}.try(:first)
  end

  def get_path(wiki, dir = nil, page = nil)
    [wiki, dir, page].delete_if {|x| x.nil?}
  end

  def get_dirs(wiki, dir)
    return [] unless dir.blank?
    wiki.pages.map do |x|
      pu = x.url_path
      if pu.include? '/'
        pu.split('/')[0]
      else
        ""
      end
    end.delete_if {|x| x.blank?}.uniq.sort
  end

  def get_pages(wiki, dir)
    if dir.blank?
      wiki.pages.select {|x| ! x.url_path.include? '/'}
    else
      wiki.pages.select {|x| x.url_path.include? "#{dir}/"}
    end
  end


end
