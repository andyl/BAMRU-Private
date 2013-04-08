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
    @cert.position = -1
    @member.certs << @cert
    @member.save
    cert_list = @member.certs.where(:typ => @cert.typ).order('position ASC')
    cert_list.each_with_index do |cert, idx|
      cert.position = idx + 1
      cert.save
    end
    ActiveSupport::Notifications.instrument("alert.CreateCert", {:member => current_member, :tgt => @cert})
    expire_fragment(/unit_certs_table/)
    redirect_to member_certs_path(@member)
  end

  def update
    @member    = Member.where(:id => params['member_id']).first
    @cert      = Cert.where(:id => params['id']).first
    @cert.cert = nil if params['check_del'] == "on"
    if @cert.update_attributes(params[:cert])
      expire_fragment(/unit_certs_table/)
      ActiveSupport::Notifications.instrument("alert.UpdateCert", {:member => current_member, :tgt => @cert})
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
    typ = @cert.typ
    ActiveSupport::Notifications.instrument("alert.DeleteCert", {:member => current_member, :tgt => @cert})
    @cert.destroy
    cert_list = @member.certs.where(:typ => @cert.typ).order('position ASC')
    cert_list.each_with_index do |cert, idx|
      cert.position = idx + 1
      cert.save
    end
    expire_fragment(/unit_certs_table/)
    redirect_to member_certs_path(@member), :notice => "Cert was Deleted"
  end

  def sort
    expire_fragment(/unit_certs_table/)
    params['cert'].each_with_index do |id, index|
      Cert.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end

end
