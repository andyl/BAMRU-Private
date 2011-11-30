# Find all elements of CSS class "sparkline", parse their content as
# a series of numbers, and replace it with a graphical representation.
#
# Define sparklines with markup like this:
#   <span class="sparkline">3 5 7 6 6 9 11 15</span>
#
# Style sparklines with CSS like this:
#   .sparkline { background-color: #ddd; color: red; }
#
# - Sparkline color is from the computed style of the CSS color property.
# - Sparklines are transparent, so the normal background color shows through.
# - Sparkline height is from the data-height attribute if defined or from
#   the computed style for the font-size otherwise.
# - Sparkline width is from the data-width attribute if it is defined
#   or the number of data points times data-dx if that is defined or
#   the number of data points times the height divided by 6
# - The minimum and maximum values of the y axis are taken from the data-ymin
#   and data-ymax attributes if they are defined, and otherwise come from
#   the minimum and maximum values of the data.


#$(document).ready ->
#  elts = document.getElementsByClassName("sparkline")
#  _.each elts, (e) -> generateSparkline(e)

window.generateSparkline = (elt) ->
  content = elt.textContent or elt.innerText
  content = content.replace(/^\s+|\s+$/g, "")
  text = content.replace(/#.*$/g, "")
  text = text.replace(/[\n\r\t\v\f]/g, " ")
  data = text.split(/\s+|\s*,\s*/)
  i = 0

  while i < data.length
    data[i] = Number(data[i])
    abort = true  if isNaN(data[i])
    return  if isNaN(data[i])
    i++

  # Now compute the color, width, height, and y axis bounds of the
  # sparkline from the data, from data- attributes of the element,
  # and from the computed style of the element.
  style = getComputedStyle(elt, null)
  color = style.color
  height = parseInt(elt.getAttribute("data-height")) or parseInt(style.fontSize) or 20
  width = parseInt(elt.getAttribute("data-width")) or data.length * (parseInt(elt.getAttribute("data-dx")) or height / 6)
  ymin = parseInt(elt.getAttribute("data-ymin")) or Math.min.apply(Math, data)
  ymax = parseInt(elt.getAttribute("data-ymax")) or Math.max.apply(Math, data)
  ymax = ymin + 1  if ymin >= ymax

  # Create the canvas element.
  canvas = document.createElement("canvas")
  canvas.width = width
  canvas.height = height
  canvas.title = content
  elt.innerHTML = ""
  elt.appendChild canvas

  # Plot the points.
  context = canvas.getContext("2d")
  i = 0
  while i < data.length
    x = width * i / data.length
    y = (ymax - data[i]) * height / (ymax - ymin)
    context.lineTo x, y
    i++
  context.strokeStyle = color
  context.stroke()
