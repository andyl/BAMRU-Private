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
  hShowDate: ->
    return "" if _.string.isBlank(@start)
    date = @hGenerateDate()
    return "#{date.startDay} (all day)" if _.string.isBlank(@finish)
    return "#{date.startDay} to #{date.finishDay} (all day)" if @all_day
    return "#{date.startDay} from #{date.startTime} to #{date.finishTime}" if date.startDay == date.finishDay
    "#{date.startDay} #{date.startTime} to #{date.finishDay} #{date.finishTime}"
  hGenerateDate: ->
    date = {}
    dayFmt    = '%a %Y-%b-%d'
    timeFmt   = '%H:%M'
    startObj  = moment(@start, "YYYY-MM-DD HH:mm")
    finishObj = moment(@finish, "YYYY-MM-DD HH:mm")
    date.startDay   = startObj.strftime(dayFmt)    if startObj
    date.startTime  = startObj.strftime(timeFmt)   if startObj
    date.finishDay  = finishObj.strftime(dayFmt)   if finishObj
    date.finishTime = finishObj.strftime(timeFmt)  if finishObj
    date

