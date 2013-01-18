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
    if data = params['photo-data']
      img_hdr, img_data = data.split(',')
      img_typ = img_hdr.split('/')[1].split(';')[0]
      sio_data = StringIO.new(Base64.decode64(img_data))
      sio_data.define_singleton_method(:content_type) do "image/#{img_typ}" end
      sio_data.define_singleton_method(:original_filename) do "canvas.#{img_typ}" end
      File.open("/tmp/upload.#{img_typ}", 'wb') {|f| f.write(Base64.decode64(img_data))}
      params[:photo] = {}
      params[:photo][:image] = sio_data
      params.delete('photo-data')
    end
    @member.photos.create(params[:photo])
    @member.save
    expire_fragment(/unit_photos_table/)
    expire_fragment(/guests_index_table/)
    SpriteGen.clear_sprite_icons
    path = @member.is_guest ? edit_guest_path(@member) : edit_member_path(@member)
    redirect_to path
  end

  def destroy
    @member = Member.where(:id => params['member_id']).first
    @photo = Photo.where(:id => params['id']).first
    @photo.destroy
    expire_fragment(/unit_photos_table/)
    expire_fragment(/guests_index_table/)
    SpriteGen.clear_sprite_icons
    path = @member.is_guest ? edit_guest_path(@member) : edit_member_path(@member)
    redirect_to path
  end

  def sort
    params[:photos].each_with_index do |id, index|
      Photo.update_all(['position=?', index+1], ['id=?', id])
    end
    expire_fragment(/unit_photos_table/)
    expire_fragment(/guests_index_table/)
    SpriteGen.clear_sprite_icons
    render :nothing => true
  end

end
