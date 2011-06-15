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

  def thumb_image(photo)
    <<-EOF
      <a href='#{photo.image.url}' target='_blank'>
        #{image_tag(photo.image.url(:icon), :class => "roster_icon_photo")}
      </a>
    EOF
  end

  def display_extra_photos(mem)
    return "" if mem.nil? || mem.photos.length < 2
    return "<tr align=center><td>-</td></tr>" if mem.nil? || mem.photos.length < 2
    photo_links = mem.photos[1..-1].map do |p|
      thumb_image(p) 
    end.join(' ')
    "<tr height=30 align=center><td>#{photo_links}</td></tr>"
  end
end
