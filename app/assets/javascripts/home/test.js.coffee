#= require backbone-min-053

window.app = {}
app.controllers = {}
app.models = {}
app.views = {}

class window.MainController #extends Backbone.Controller
#  routes:
#    ""     : "home"
#    "home" : "home"
#  home: ->
#    app.views.counter.render()

class window.Counter extends Backbone.Model
  defaults:
    count: 0

class window.CounterView #extends Backbone.View
#  initialize: ->
#    @counter = new Counter()
#    @render()
#  el: $('#counter')
#  events:
#    'click button#inc-count' : 'inc'
#    'click button#dec-count' : 'dec'
#  render: ->
#    $(@el).find("#count").html "The count is " \
#      + @counter.get("count")
#    @
#  inc: ->
#    ct = @counter.get("count")
#    @counter.set(count: ct+1)
#    @render()
#  dec: ->
#    ct = @counter.get("count")
#    @counter.set(count: ct-1)
#    @render()

$(document).ready ->
  app.controllers.main = new MainController()
  app.views.counter = new CounterView()
  app.models.counter = new Counter()
#  Backbone.history.start()