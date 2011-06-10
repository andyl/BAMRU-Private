class CertsController < ApplicationController
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
    redirect_to member_certs_path(@member)
  end

  def show
    @member = Member.where(:id => params['member_id']).first
    @cert = Cert.where(:id => params['id']).first
  end

  def edit
    @member = Member.where(:id => params['member_id']).first
    @cert = Cert.where(:id => params['id']).first
  end

end
