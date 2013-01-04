class @M3_CommonView extends Backbone.View
  blue_wrap: (text) ->
    "<span style='background-color: lightblue; padding-left 3px; padding-right 3px;'>#{text}</span>"
  random_string: ->
    (Math.random() + '').replace('.','')