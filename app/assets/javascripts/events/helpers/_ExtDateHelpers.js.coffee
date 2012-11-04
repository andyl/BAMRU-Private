BB.Helpers.ExtDateHelpers =
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