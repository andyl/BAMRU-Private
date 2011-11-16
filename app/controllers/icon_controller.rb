class IconController < ApplicationController

  #noinspection RubyDeadCode
  def mark_as_read(label)
    om = OutboundMail.where(:label => label).first
    return if om.nil?
    dist = om.distribution
    return if dist.read
    x_hash = {
            :distribution_id => dist.id,
            :member_id       => dist.member.id,
            :action          => "Read via HTML eMail"
    }
    Journal.create(x_hash)
    dist.read = true
    dist.save
  end

  def show
    mark_as_read(params[:label])
    response.headers['Cache-Control']       = "public, max-age=5"
    response.headers['Content-Type']        = "image/gif"
    response.headers['Content-Disposition'] = "inline"
    icon_file                               = Rails.root.to_s + "/public/axe.gif"
    render :text => open(icon_file, "rb").read
  end

end
