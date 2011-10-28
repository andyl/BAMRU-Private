# Code to instantiate the timer

window.time = 0

window.playDing = ->
  ding = new Audio("ding.wav")
  ding.play()

window.tick = ->
  window.time = window.time - 1
  window.displayTime()
  window.countDown = window.setTimeout("tick()", 1000) if window.time > 0
  if window.time <= 0
    playDing()
    clearTimer()

window.numPad = (num) ->
  return num unless num < 10
  return "0#{num}"

window.timeInMin = ->
  mins = Math.floor(window.time / 60)
  secs = window.time % 60
  "#{numPad(mins)}:#{numPad(secs)}"

window.displayTime = ->
  text = if window.time <= 0 then "Time" else window.timeInMin()
  $('#time').text(text)

window.clearTimer = ->
  window.clearTimeout(window.countDown)
  $('#buttons a').css("border", "1px solid black")

window.startTimer = (element) ->
  id = $(element).attr("id")
  window.clearTimer()
  $(element).css("border", "2px solid black") unless id == "stp"
  window.time = switch id
    when "25m" then 25 * 60
    when "05m" then  5 * 60
    when "15m" then 15 * 60
    when "05s" then  5
    when "stp" then  0
  displayTime()
  window.countDown = window.setTimeout("tick()", 1000) unless id == "stp"

window.hideAddressBar = ->
  if navigator.userAgent.match(/Android/i)
    window.scrollTo(0,1)

window.setButtonOrientation = ->
  if $(window).height() > $(window).width()
    $('#buttons a').css("display", "block")
  else
    $('#buttons a').css("display", "inline")

window.setScreen = ->
  hideAddressBar()
  setButtonOrientation()

$(document).ready ->
  $('#buttons a').click -> startTimer(this)
  window.setScreen()
  $(window).bind 'resize', ->
    setScreen()
