class IconController < ApplicationController

  def show
    mark_as_read(params[:label])
    response.headers['Cache-Control']       = "public, max-age=5"
    response.headers['Content-Type']        = "image/gif"
    response.headers['Content-Disposition'] = "inline"
    icon_file                               = Rails.root.to_s + "/public/axe.gif"
    render :text => open(icon_file, "rb").read
  end

  private

  def mark_as_read(label)
    om = OutboundMail.where(:label => label).first
    return if om.nil?
    dist = om.distribution
    dist.mark_as_read(dist.member, "Read via HTML eMail (#{label})")
  end

end
