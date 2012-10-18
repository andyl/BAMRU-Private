window.mDate = (input) ->
  return moment() if input == null
  target = if input[0] == 2
    input
  else
    "01 " + input.replace('-', ' ')
  moment(target)

window.reduceObj = (list, func) -> _.reduce list, func, {}

window.reduceArr = (list, func) -> _.reduce list, func, []