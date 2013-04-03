require 'gollum-lib'

class WikiController < ApplicationController

  before_filter :authenticate_member!

  def index
    @wiki  = Gollum::Wiki.new(Rails.root.join('wiki').to_s)
    @dir   = params[:dir]
    @path  = get_path(@wiki, @dir)
    @dirs  = get_dirs(@wiki, @dir)
    @pages = get_pages(@wiki, @dir)
  end
  
  def new
    @dir = params[:dir]
  end

  def show
    @wiki  = Gollum::Wiki.new(Rails.root.join('wiki').to_s, :base_path => "../wiki")
    @dir = params['dir']
    page = params['page']
    @path  = get_path(@wiki, @dir, page)
    @dirs  = get_dirs(@wiki, @dir)
    @pages = get_pages(@wiki, @dir)
    @page = @pages.select {|x| x.name == page}.try(:first)
  end

  def create
    #@member = current_member
    #@file    = DataFile.create(params[:data_file])
    #@member.data_files << @file
    #if @member.save
    #  redirect_to files_path, :notice => "File saved (#{@file.data_file_name})"
    #else
    #  string = @file.errors.full_messages.join(', ')
    #  flash.now.alert = "Error: #{string}"
    #  render "new"
    #end
  end

  def edit
    @wiki  = Gollum::Wiki.new(Rails.root.join('wiki').to_s, :base_path => "../wiki")
    @dir = params['dir']
    page = params['page']
    @path  = get_path(@wiki, @dir, page)
    @dirs  = get_dirs(@wiki, @dir)
    @pages = get_pages(@wiki, @dir)
    @page = @pages.select {|x| x.name == page}.try(:first)
  end

  def rename

  end

  def update
    
  end

  def destroy
    #@file = DataFile.where(:id => params['id']).first
    #@file.destroy
    #redirect_to files_path, :notice => "File was Deleted"
  end

  private

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
      "BLANK"
      wiki.pages.select {|x| ! x.url_path.include? '/'}
    else
      wiki.pages.select {|x| x.url_path.include? "#{dir}/"}
    end
  end


end
