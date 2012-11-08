BB.Helpers.ExtDateHelpers =

  hShowDate: (start = @start, finish = @finish, all_day = @all_day, format="%a %Y-%b-%d") ->
    return "" if _.string.isBlank(start)
    date = @hGenerateDate(start, finish, format)
    return "#{date.startDay} (all day)" if _.string.isBlank(finish)
    return "#{date.startDay} to #{date.finishDay} (all day)" if all_day
    return "#{date.startDay} from #{date.startTime} to #{date.finishTime}" if date.startDay == date.finishDay
    "#{date.startDay} #{date.startTime} to #{date.finishDay} #{date.finishTime}"

  hGenerateDate: (start = @start, finish = @finish, format) ->
    date = {}
    dayFmt    = format
    timeFmt   = '%H:%M'
    startObj  = moment(start, "YYYY-MM-DD HH:mm")
    finishObj = moment(finish, "YYYY-MM-DD HH:mm") if finish
    date.startDay   = startObj.strftime(dayFmt)    if startObj
    date.startTime  = startObj.strftime(timeFmt)   if startObj
    date.finishDay  = finishObj.strftime(dayFmt)   if finishObj
    date.finishTime = finishObj.strftime(timeFmt)  if finishObj
    date