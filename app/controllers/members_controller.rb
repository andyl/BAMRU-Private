class MembersController < ApplicationController
  def index
    @members = Member.all
  end

  def show
    @member = Member.where(:id => params[:id]).first
  end

  def edit
    @member = Member.where(:id => params[:id]).first
  end
end
