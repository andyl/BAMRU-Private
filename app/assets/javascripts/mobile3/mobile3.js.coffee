#= require_self
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

#window.Mobile3 =
#  Models: {}
#  Collections: {}
#  Routers: {}
#  Views: {}

$(document).ready ->
  window.App = new M3_BaseRoute()
  Backbone.history.start()
  window.scrollTo 0, 1  if navigator.userAgent.match(/Android/i)
