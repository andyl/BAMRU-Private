class Eapi::MembersController < ApplicationController
  respond_to :json

  def index
    respond_with Member.all, opts
  end
  
  def show
    respond_with Member.find(params[:id])
  end
  
  def create
    render :json => Member.create(params[:Member])
  end
  
  def update
    respond_with Member.update(params[:id], params[:Member])
  end
  
  def destroy
    respond_with Member.destroy(params[:id])
  end

  private

  def opts
    {only: [:id, :first_name, :last_name, :typ, :admin, :developer]}
  end

end