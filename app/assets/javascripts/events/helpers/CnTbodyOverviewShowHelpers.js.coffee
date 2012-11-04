BB.Helpers.CnTbodyOverviewShowHelpers =
  hLeader: ->
    if _.string.isBlank(@leaders) then "TBA" else @leaders
  hTyp: ->
    output = _.string.capitalize(@typ)
    if output == "Special" then "Special Event" else output
  hPublished: ->
    label = if @published then "published" else "not published"
    "#{label} (<a href='/home/event_publishing' target='_blank'>learn more</a>)"
  hLatLon: ->
    return "" if _.string.isBlank(@lat)
    "(#{@lat} #{@lon} <a href='http://maps.google.com?q=#{@lat},#{@lon}' target='_blank'>map</a>)"


_.extend(BB.Helpers.CnTbodyOverviewShowHelpers, BB.Helpers.ExtDateHelpers)



