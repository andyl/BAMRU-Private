class PhotosController < ApplicationController

  before_filter :authenticate_member!

  def index
    @member = Member.where(:id => params['member_id']).first
  end

  def new
    @member = Member.where(:id => params['member_id']).first
    @path = @member.is_guest ? edit_guest_path(@member) : edit_member_path(@member)
    @photo  = Photo.new
  end

  def create
    @member = Member.where(:id => params['member_id']).first
    @member.photos.create(params[:photo])
    @member.save
    expire_fragment('unit_photos_table')
    SpriteGen.clear_sprite_icons
    path = @member.is_guest ? edit_guest_path(@member) : edit_member_path(@member)
    redirect_to path
  end

  def destroy
    @member = Member.where(:id => params['member_id']).first
    @photo = Photo.where(:id => params['id']).first
    @photo.destroy
    expire_fragment('unit_photos_table')
    SpriteGen.clear_sprite_icons
    path = @member.is_guest ? edit_guest_path(@member) : edit_member_path(@member)
    redirect_to path
  end

  def sort
    params[:photos].each_with_index do |id, index|
      Photo.update_all(['position=?', index+1], ['id=?', id])
    end
    expire_fragment('unit_photos_table')
    SpriteGen.clear_sprite_icons
    render :nothing => true
  end

end
