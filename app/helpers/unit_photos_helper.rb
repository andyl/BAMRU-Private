module UnitPhotosHelper
  def unit_member_photo(mem)
    if mem.nil?
      ""
    else
      itag = image_tag(mem.photos.first.image.url(:thumb))
      name = link_to(mem.full_name, member_path(mem))
      "#{itag}<br/>#{name}"
    end
  end
end
