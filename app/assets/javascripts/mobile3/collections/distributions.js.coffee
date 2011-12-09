class @M3_Distributions extends Backbone.Collection
  model: M3_Distribution
  url:   "/api/mobile3/distributions"
  comparator: (dist) ->
    dist.get('id') * -1
  unreadCount: ->
    filtered_list = _.filter @models, (dist) ->
      dist.get('read') == false
    filtered_list.length
  inbox: (memid) ->
    _.filter @models, (dist) -> dist.get('member_id') == memid