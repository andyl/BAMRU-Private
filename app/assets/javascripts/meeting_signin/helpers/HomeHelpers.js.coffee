BB.Helpers.HomeHelpers =

  homeTitle: ->
    date      = moment(@start).strftime("%b %d")
    "<b>#{@title}<br/>#{date} @ #{@location}</b>"
