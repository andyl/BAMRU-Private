class PhotosController < ApplicationController

  def index
    @member = Member.where(:id => params['member_id']).first
  end

  def new
    @member = Member.where(:id => params['member_id']).first
    @photo  = Photo.new
  end

  def create
    @member = Member.where(:id => params['member_id']).first
    @photo = Photo.create(params[:photo])
    @member.photos << @photo
    @member.save
    redirect_to member_photos_path(@member)
  end

end
