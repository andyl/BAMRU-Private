class CertsController < ApplicationController

  before_filter :authenticate_member!
  cache_sweeper :cert_cache_sweeper, :only => [:create, :update, :destroy]


  def index
    @member = Member.where(:id => params['member_id']).first
  end
  
  def new
    @member = Member.where(:id => params['member_id']).first
    hash = params["typ"].nil? ? {} : {:typ => params["typ"]}
    @cert   = Cert.new(hash)
  end

  def create
    @member = Member.where(:id => params['member_id']).first
    @cert   = Cert.create(params[:cert])
    @member.certs << @cert
    @member.save
    expire_fragment(/^unit_certs_table.*$/)
    redirect_to member_certs_path(@member)
  end

  def update
    @member = Member.where(:id => params['member_id']).first
    @cert   = Cert.where(:id => params['id']).first
    if @cert.update_attributes(params[:cert])
      expire_fragment(/^unit_certs_table.*$/)
      redirect_to member_certs_path(@member), :notice => "Successful Update"
    else
      render "edit"
    end
  end

  def show
    @member = Member.where(:id => params['member_id']).first
    @cert = Cert.where(:id => params['id']).first
  end

  def edit
    @member = Member.where(:id => params['member_id']).first
    @cert = Cert.where(:id => params['id']).first
  end

  def destroy
    @member = Member.where(:id => params['member_id']).first
    @cert = Cert.where(:id => params['id']).first
    @cert.destroy
    expire_fragment(/^unit_certs_table.*$/)
    redirect_to member_certs_path(@member), :notice => "Cert was Deleted"
  end

end
