class @M3_Distributions extends Backbone.Collection
  model: M3_Distribution
  url:   "/api/mobile3/distributions"
  unreadCount: ->
    filtered_list = _.filter @models, (dist) ->
      dist.get('read') == "no"
      messages.get(id) != undefined
    filtered_list.length()