#= require mobile3/models/common_model

window.distributions = []
#window.myid  = 24

class @M3_Message extends M3_CommonModel
  initialize: ->
    obj = @
    if @has('distributions')
      @distributions = new M3_Distributions @get('distributions')
      _(@distributions.models).each (dist) ->
        dist.set({'message': obj})
        window.distributions = window.distributions.concat(dist) if dist.get('member_id') == window.myid
  hasRSVP:      -> @has('rsvp_prompt')
  sentCount:    -> @distributions.models.length
  readCount:    ->
    val = _(@distributions.models).select (dist)->
      dist.get('read') == "yes"
    val.length
  unreadCount:  ->
    val = _(@distributions.models).select (dist)->
      dist.get('read') == "no"
    val.length
  rsvpYesCount: ->
    val = _(@distributions.models).select (dist)->
      dist.get('rsvp') == "yes"
    val.length
  rsvpNoCount:  ->
    val = _(@distributions.models).select (dist)->
      dist.get('rsvp') == "no"
    val.length
  markAsRead: ->
    dist = _(@distributions.models).select (dist) ->
      dist.get('member_id') == myID
    return if dist.length == 0
    window.fdist = dist[0]
    return unless navigator.onLine
#    $.post('/api/mobile3/distributions/1/markread')
    console.log "GOING TO SET FDIST TO TRUE"
    console.log fdist
    console.log fdist.get('name')
    fdist.set({'read':'yes'})
    console.log fdist
    console.log fdist.get('read')


