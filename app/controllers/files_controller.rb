class FilesController < ApplicationController

  before_filter :authenticate_member!
  cache_sweeper :file_cache_sweeper, :only => [:create, :destroy, :show]


  def index
    @files = DataFile.all
  end
  
  def new
    @file = DataFile.new()
  end

  def create
    @member = current_member
    @file    = DataFile.create(params[:data_file])
    @member.data_files << @file
    if @member.save
      redirect_to files_path, :notice => "File saved (#{@file.data_file_name})"
    else
      flash.now.alert = "Error: file upload error - please try again"
      render "new"
    end
  end

  def show
    filename = "#{params['id']}.#{params['format']}"
    @file = DataFile.where(:data_file_name => filename).first
    unless @file.nil?
      @file.download_count += 1
      @file.save
      expire_fragment('files_table')
      render :text => File.read(@file.data.path), :content_type => @file.data_content_type
    else
      redirect_to files_path, :alert => "File was not found (#{filename})"
    end
  end

  def destroy
    @file = DataFile.where(:id => params['id']).first
    @file.destroy
    redirect_to files_path, :notice => "File was Deleted"
  end

end
