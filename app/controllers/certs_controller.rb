class CertsController < ApplicationController
  def index
    @member = Member.where(:id => params['member_id']).first
  end
  
  def new
    @member = Member.where(:id => params['member_id']).first
    @cert   = Cert.new
  end

  def create
    @member = Member.where(:id => params['member_id']).first
    @cert   = Cert.create(params[:cert])
    @member.certs << @cert
    @member.save
    redirect_to member_certs_path(@member)
  end
end
