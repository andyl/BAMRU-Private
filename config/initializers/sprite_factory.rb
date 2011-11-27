require 'sprite_factory'

class SpriteGen

  SPRITE_ICON_DIR = Rails.root.to_s + '/public/images/icons'

  def self.clear_sprite_icons
    system "rm -rf #{SPRITE_ICON_DIR}"
    system "rm -f  #{SPRITE_ICON_DIR}.css"
    system "rm -f  #{SPRITE_ICON_DIR}.png"
  end

  def self.generate_sprites
    puts '*' * 60
    puts "GENERATING SPRITES for #{SPRITE_ICON_DIR}"
    puts '*' * 60
    SpriteFactory.run!(SPRITE_ICON_DIR)
    #, :csspath => "images/")
  end

  def self.generate_sprite_icons
    return if File.exist? SPRITE_ICON_DIR
    photos = Photo.where(:position => 1).all
    system "mkdir #{SPRITE_ICON_DIR}"
    photos.each do |photo|
      mem_id = photo.member.last_name.downcase
      icon_p = photo.image.path(:icon)
      system "cp #{icon_p} #{SPRITE_ICON_DIR}/#{mem_id}.jpg"
    end
    self.generate_sprites
  end

end