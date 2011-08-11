class DocsController < ApplicationController

  before_filter :authenticate_member!
  cache_sweeper :cert_cache_sweeper, :only => [:create, :update, :destroy]


  def index
    @docs = Doc.all
  end
  
  def new
    @member = Member.where(:id => params['member_id']).first
    hash = params["typ"].nil? ? {} : {:typ => params["typ"]}
    @cert   = Doc.new(hash)
  end

  def create
    @member = Member.where(:id => params['member_id']).first
    @cert   = Doc.create(params[:cert])
    @member.certs << @cert
    @member.save
    redirect_to member_certs_path(@member)
  end

  def update
    @member = Member.where(:id => params['member_id']).first
    @cert   = Doc.where(:id => params['id']).first
    if @cert.update_attributes(params[:cert])
      redirect_to member_certs_path(@member), :notice => "Successful Update"
    else
      render "edit"
    end
  end

  def show
    @member = Member.where(:id => params['member_id']).first
    @cert = Doc.where(:id => params['id']).first
  end

  def edit
    @member = Member.where(:id => params['member_id']).first
    @cert = Doc.where(:id => params['id']).first
  end

  def destroy
    @member = Member.where(:id => params['member_id']).first
    @cert = Doc.where(:id => params['id']).first
    @cert.destroy
    redirect_to member_certs_path(@member), :notice => "Doc was Deleted"
  end

end
