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

  def display_extra_photos(mem)
    return "" if mem.nil? || mem.photos.length < 2
    return "<tr align=center><td>-</td></tr>" if mem.nil? || mem.photos.length < 2
    photo_links = mem.photos[1..-1].map do |p|
      image_tag(p.image.url(:icon), :class => "roster_icon_photo")
    end.join(' ')
    "<tr height=30 align=center><td>#{photo_links}</td></tr>"
  end
end
