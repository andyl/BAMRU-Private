class BB.Collections.Distributions extends Backbone.Collection

  model: BB.Models.Distribution

  url:   "/api/mobile/distributions"

  comparator: (dist) ->
    dist.get('id') * -1

  unreadCount: ->
    filtered_list = _.filter @models, (dist) ->
      dist.get('read') == false
    filtered_list.length

  inbox: (memid) ->
    _.filter @models, (dist) -> dist.get('member_id') == memid