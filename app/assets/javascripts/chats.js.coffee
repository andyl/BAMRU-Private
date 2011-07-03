# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  faye = new Faye.Client('http://ekel:9292/faye')
  faye.subscribe("/chats/new", (data) -> eval(data))
