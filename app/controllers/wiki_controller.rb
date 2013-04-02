require 'gollum-lib'

class WikiController < ApplicationController

  before_filter :authenticate_member!

  def index
    @wiki  = Gollum::Wiki.new(Rails.root.join('wiki').to_s)
    @pages = @wiki.pages.sort {|a,b| a.url_path <=> b.url_path}
  end
  
  def new
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

  def show
    url_path = params['id']
    @wiki  = Gollum::Wiki.new(Rails.root.join('wiki').to_s, :base_path => "../wiki")
    @pages = @wiki.pages
    @page = @pages.select {|x| x.url_path == url_path}.try(:first)
  end

  def edit

  end

  def update
    
  end

  def destroy
    #@file = DataFile.where(:id => params['id']).first
    #@file.destroy
    #redirect_to files_path, :notice => "File was Deleted"
  end

end
