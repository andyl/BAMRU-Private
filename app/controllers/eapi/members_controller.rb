class Eapi::MembersController < ApplicationController
  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  def index
    respond_with Member.all, opts
  end
  
  def show
    respond_with Member.find(params[:id]), opts
  end
  
  def create
    model = Member.create(params["member"])
    debugger
    if model.valid?
      expire_fragment(/guests_index_table/)
      respond_with model, opts
    else
      render :json => {errors: model.errors.full_messages}, status: 422
    end
  end
  
  def update
    respond_with Member.update(params[:id], params[:Member])
  end
  
  def destroy
    respond_with Member.destroy(params[:id])
  end

  private

  def opts
    {only: [:id, :first_name, :last_name, :typ, :admin, :developer], methods: :photo_icon}
  end

end