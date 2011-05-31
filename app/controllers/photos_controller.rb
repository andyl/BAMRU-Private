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

  def destroy
    @member = Member.where(:id => params['member_id']).first
    @photo = Photo.where(:id => params['id']).first
    @photo.destroy
    redirect_to edit_member_path @member
  end

  def sort
    params[:photos].each_with_index do |id, index|
      Photo.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end

end
