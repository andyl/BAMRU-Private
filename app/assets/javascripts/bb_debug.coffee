# This code generates a menu for debugging Backbone Apps
# It generates a menu listing all of the Backbone Views on your page.
#
# To use it, add classNames to your Backbone Views using the
# format "bb-ClassName".
#
# The code assumes that the global namespace for the app is "BB".
#
# Next Steps:
# - add mouseover menus to set color classes
# - see http://alienryderflex.com/mouseover_menus_example.html
# - make the color settings persistent using cookies or local_storage

# ----- element identifiers -----

debugFooter   = 'debug_footer'
debugBb       = 'debug_bb'

debugFooterId  = "##{debugFooter}"
debugBbId      = "##{debugBb}"

# ----- find the BB classes on a page -----

# incrementFrequencyCounter({}, 'a')        # => {'a': 1}
# incrementFrequencyCounter({'a': 1}, 'a')  # => {'a': 2}
# incrementFrequencyCounter({'a': 2}, 'b')  # => {'a': 2, 'b': 1}
incrementFrequencyCounter = (counterObj, key) ->
  if counterObj[key]? then counterObj[key] += 1 else counterObj[key] = 1
  counterObj

# extractClassName([], "bb-Asdf Other")                # => ["Asdf"]
# extractClassName(["Asdf"], "bb-Asdf")                # => ["Asdf", "Asdf"]
# extractClassName(["Asdf", "Asdf"], "bb-Qwer Other")  # => ["Asdf", "Asdf", "Qwer"]
extractClassName = (classNameArray, classString) ->
  splitNames = classString.split(' ')
  cleanNames = _.filter(splitNames, (e) -> _.string.startsWith(e, "bb-"))
  stripNames = _.map(cleanNames, (e) -> e.split('bb-')[1])
  classNameArray.concat(stripNames)

generateLabel = (label, freq) ->
  if freq == 1 then label else "#{label}:#{freq}"

generateWrapper = (label) ->
  minLabel = label.split(':')[0]
  "<span class='bbWrapper' data-klass='bb-#{minLabel}'>#{label}</span>"

generateBbDebugMenu = ->
  elements = $("[class^=bb-]")
  baseNames = _.map elements, (e) -> $(e).attr("class")
  procNames = _.reduce(baseNames, extractClassName, [])
  freqNames = _.reduce(procNames, incrementFrequencyCounter, {})
  labels    = _.map(Object.keys(freqNames), (key) -> generateLabel(key, freqNames[key]))
  wrappers  = _.map(labels.sort(), (label) -> generateWrapper(label))
  wrappers.join(' | ')

# ----- debug menu -----

addBbDebugDivToFooter = ->
  html = "<div id='#{debugBb}' class='debug'><b>BB</b></div>"
  $(debugFooterId).append(html)
  $(window).resize()

updateBbDebugFooter = (html) ->
  $(debugBbId).html(html)

updateBbDebugMenu = ->
  debugHtml = generateBbDebugMenu()
  updateBbDebugFooter(debugHtml)
  setupViewHighlighting()

autoUpdateBbDebugMenu = ->
  if BB.Routers.app?
    BB.Routers.app.on('all', (router, route, args) -> updateBbDebugMenu())
  if BB.vent?
    BB.vent.on('all', () -> updateBbDebugMenu())

setupBbDebugMenu = ->
  if BB?                     # if the global namespace 'BB' exists
    addBbDebugDivToFooter()
    updateBbDebugMenu()
    autoUpdateBbDebugMenu()

# ----- view highlighting -----

setBackground = (targetElement, color) ->
  targetKlass = $(targetElement).data("klass")
  $(targetElement).css("background", color)
  $(".#{targetKlass}").css("background", color)

setupViewHighlighting = ->
  $(".bbWrapper").hover (event)      -> setBackground(event.target, "yellow")
  $(".bbWrapper").mouseleave (event) -> setBackground(event.target, "")

# ----- initializer -----

$(document).ready ->
  window.setTimeout(setupBbDebugMenu, 1000)

