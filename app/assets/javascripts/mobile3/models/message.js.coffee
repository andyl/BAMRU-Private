#= require mobile3/models/common_model

class @M3_Message extends M3_CommonModel
  unitRoster: ->
    return @get('unitRoster') if @has('unitRoster')
    return members unless members == undefined
    null
  author: ->
    return null if @unitRoster() == null
    @unitRoster().get(@get('author_id'))
  unitDistributions: ->
    return @get('unitDistributions') if @has('unitDistributions')
    return distributions unless distributions == undefined
    null
  distributions: ->
    return null if @unitDistributions() == null
    msgID = @get('id')
    vals = @unitDistributions().select (dist) ->
      dist.get('message_id') == msgID
    new M3_Distributions vals
  hasRSVP:      -> @has('rsvp_prompt')
  sentCount:    ->
    @distributions().length
  readCount:    ->
    val = _(@distributions().models).select (dist)->
      dist.get('read') == true
    val.length
  unreadCount:  ->
    val = _(@distributions().models).select (dist)->
      dist.get('read') == false
    val.length
  rsvpYesCount: ->
    val = _(@distributions().models).select (dist)->
      dist.get('rsvp_answer') == "Yes"
    val.length
  rsvpNoCount:  ->
    val = _(@distributions().models).select (dist)->
      dist.get('rsvp_answer') == "No"
    val.length
  markAsRead: ->
    return unless navigator.onLine
    dist = _(@distributions().models).select (dist) ->
      dist.get('member_id') == myID
    return if dist.length == 0
    window.fdist = dist[0]
    fdist.set({'read':true}) unless fdist.get('read') == true


