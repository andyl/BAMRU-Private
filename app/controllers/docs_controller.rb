class DocsController < ApplicationController

  before_filter :authenticate_member!
  cache_sweeper :cert_cache_sweeper, :only => [:create, :update, :destroy]


  def index
    @docs = Doc.all
  end
  
  def new
    @doc   = Doc.new()
  end

  def create
    @member = current_member
    @doc    = Doc.create(params[:doc])
    @member.docs << @doc
    if @member.save
      redirect_to docs_path, :notice => "Doc saved (#{@doc.doc_file_name})"
    else
      render "new"
    end
  end

  def show
    filename = "#{params['id']}.#{params['format']}"
    @doc = Doc.where(:doc_file_name => filename).first
    unless @doc.nil?
      @doc.download_count += 1
      @doc.save
      redirect_to @doc.doc.url
    else
      redirect_to docs_path, :alert => "Doc was not found (#{filename})"
    end
  end

  def destroy
    @doc = Doc.where(:id => params['id']).first
    @doc.destroy
    redirect_to docs_path, :notice => "Doc was Deleted"
  end

end
